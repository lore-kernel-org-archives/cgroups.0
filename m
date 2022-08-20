From: "Chris Murphy" <lists-zXQU9YWDTqjmlV4oE/1sFAC/G2K4zDHf@public.gmane.org>
Subject: oomd with 6.0-rc1 has ridiculously high memory pressure stats wit
Date: Fri, 19 Aug 2022 22:51:27 -0400
Message-ID: <d0df567c-1f6a-418d-8db7-3f777bd109c8@www.fastmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        colorremedies.com; h=cc:content-type:date:date:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1660963908; x=1660967508; bh=CySVD2aXxm
        hI+TuehF6fV37tTPOWww490mlaiYMjGoQ=; b=MrQ4H/yqRLgd4uB4MJG3Bm2A/v
        80UcBetvHM95cQC0BWqLIaSFaUaUy68q0hpHlO/dyXYUI0lhJAXgneJGibYnFFa+
        oKQ5GS693Ksr9CeFLI4Xi4DW3a+CAcnc1ddRTQGMB9yFurUluAm47UjfcIeaHUD1
        HElFhvxoBHMtpaU8dflueA1DhSjUPlYIm9hQqHOfZQH8XPoJO8wxmJkKgGt8vTfz
        yIcWAmOEQmywwl05GFizYBuhmJ0SFa8SKIBbJ7lCc7y6ItLHaNohe1VxMjiIoj6M
        MqdF0cJqyp8BQAPcLLwrRFhjkH5923I8dnWGlofUV/ybyUs7OOn3ydr3jUGQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:message-id:mime-version
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1660963908; x=
        1660967508; bh=CySVD2aXxmhI+TuehF6fV37tTPOWww490mlaiYMjGoQ=; b=0
        SiUMNo4dXrPnteHYqVhOgZeN9vtAJ56CaIxKFW0YRxFDg0FsqkkCSb5VP8YNE2q6
        EQllrv5cC3zoNkS6kKW3hBUFVmQVxA6eKkhOmGE3URI3gToBNxpHhWS5xp+NN9on
        Yr1WkRfubBaSGU/C2qEhXnXjg5NLk6qTzLp+orDtuMMwVMj4kUaQF1YEuId+ZPgv
        vAyhmnpm8MT56er9sDfhPWbC2a6OOYwvxzZ/vX+5BRctswKTgyFyRushEq9Tf5vV
        TPWu+fwGCChbR4IK4RNGVYWLpVSH33JPussbXekbigpafVI3vVF5ay866juyWe2w
        Ri6Z5jrV8LmVLdMaNtU4Q==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

Tracking a downstream bug in Fedora Rawhide testing, where 6.0-rc1 has landed, and we're seeing various GNOME components getting kllled off by systemd-oomd, with the stats showing suspiciously high values:

https://bugzilla.redhat.com/show_bug.cgi?id=2119518

e.g.

Killed /user.slice/user-1000.slice/user-HmGangybm7RTDjBF/Jpztg@public.gmane.org/session.slice/org.gnome.Shell-r28gBBs99rhXz5zEmyOJwQ@public.gmane.org due to memory pressure for /user.slice/user-1000.slice/user-HmGangybm7RTDjBF/Jpztg@public.gmane.org being 27925460729.27% > 50.00% for > 20s with reclaim activity

I'm not seeing evidence of high memory pressure in /proc/pressure though, whereas oomd is reporting really high memory pressure and absolute time for it that makes no sense at all:

>>Sep 09 03:01:05 fedora systemd-oomd[604]:                 Pressure: Avg10: 1255260529528.42 Avg60: 325612.68 Avg300: 757127258245.62 Total: 2month 4w 2d 8h 15min 12s

It's been up for about 2 minutes at this point, not 3 months.

Thanks,

