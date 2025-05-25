#!/usr/bin/env python

import sys
import warnings
import vobject


def smart_truncate(content, length=100, suffix='…'):
    if len(content) <= length:
        return content
    else:
        return ' '.join(content[:length+1].split(' ')[0:-1]) + suffix


def get_invitation_from_path(path):
    with open(path) as f:
        try:
            # vobject uses deprecated Exceptions
            with warnings.catch_warnings():
                warnings.simplefilter("ignore")
                return vobject.readOne(f, ignoreUnreadable=True)
        except AttributeError:
            return vobject.readOne(f, ignoreUnreadable=True)


def person_string(c):
    return "%s %s" % (c.params['CN'][0], "<%s>" % c.value.split(':')[1])


def when_str_of_start_end(s, e):
    date_format = "%a, %d %b %Y at %H:%M"
    until_format = "%H:%M" if s.date() == e.date() else date_format
    return "%s -- %s" % (s.strftime(date_format), e.strftime(until_format))


def pretty_print_invitation(invitation):
    event = invitation.vevent.contents
    if (invitation.method.value == 'REPLY'):
        print(event['summary'][0].value)
    else:
        CONTENT_WIDTH = 70
        title = event['summary'][0].value
        org = event['organizer'][0] if 'organizer' in event else 'none'
        invitees = event['attendee']
        start = event['dtstart'][0].value
        end = event['dtend'][0].value
        location = event['location'][0].value
        description = event['description'][0].value if 'description' in event else 'none'
        print("")
        print("\u001b[48m", " "*CONTENT_WIDTH, "\u001b[0m")
        print("\u001b[48;1;37m",
              ("Event Invitation").center(CONTENT_WIDTH), "\u001b[0m",)
        print("\u001b[48;37m",
              (smart_truncate(title.strip(), 68)).center(CONTENT_WIDTH), "\u001b[0m",)
        print("\u001b[48m", " "*CONTENT_WIDTH, "\u001b[0m")
        # print("Event Name: %s" % title.strip())
        print("")
        print("Date/Time:   %s" % when_str_of_start_end(start, end))
        print("Location:    %s" % (location or (
            'Microsoft Teams meeting' if 'Microsoft Teams meeting' in description else '<None>')))
        print("Organiser:   %s" % person_string(org))

        print("\n%s\n\n" % description)

        print("Invitees:")
        for i in invitees:
            print("  %s" % person_string(i) if i else '')


if __name__ == "__main__":
    if len(sys.argv) != 2 or sys.argv[1].startswith('-'):
        sys.stderr.write("Usage: %s <filename.ics>\n" % sys.argv[0])
        sys.exit(2)
    inv = get_invitation_from_path(sys.argv[1])
    pretty_print_invitation(inv)
