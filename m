From: Patrick Reader <_@pxeger.com>
Subject: v2 cpu.max question
Date: Sun, 9 May 2021 13:20:14 +0000
Message-ID: <0102017951491312-b3c91c35-577a-466c-965b-fa004d314980-000000@eu-west-1.amazonses.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=tqv4uysrlnm4medenf5ivv2dv3fy2re7; d=pxeger.com; t=1620566414;
        h=From:To:Subject:Message-ID:Date:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=Wzf2ZYdzYwPSwxlvvNXWZXEuY6BAfTpoORaP45e2ZO8=;
        b=WecsRAg2WOIBkFJn8/lFyDdQLzghj15Y9ny1kEL2sL5hmmZiu0T8awjD+zryD7lq
        tz/a617fMRvzFf/W/8CAc0F+LlvXznwFrUoNDpdd/IybnWvnqyDqaYpGSCWVhwE1NUi
        PKGz2XePeEsfQ/B7qQPviWaXgSZUigjhhStwFsxo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=uku4taia5b5tsbglxyj6zym32efj7xqv; d=amazonses.com; t=1620566414;
        h=From:To:Subject:Message-ID:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:Feedback-ID;
        bh=Wzf2ZYdzYwPSwxlvvNXWZXEuY6BAfTpoORaP45e2ZO8=;
        b=aAwU/hpdYo/Bdl9gE9tJezkoSccn1soOsLqslL765rOxTBk+Z8Mw76E+ZaWurzRN
        IUbCjybGJwnNx5cSAhVB1c6YIEVrtcAswmtJXdzvydOfF5IqrTR/463INKWuKFjXq13
        gVChpR/1lXKOPtVBcvmUT0thXcdiCSah7dphp6xM=
Content-Language: en-GB
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

I have a question about cgroup v2's `cpu.max` value. The documentation (https://www.kernel.org/doc/html/latest/admin-guide/cgroup-v2.html#cpu-interface-files) says:

> cpu.max
>
>     A read-write two value file which exists on non-root cgroups. The default is “max 100000”.
>
>     The maximum bandwidth limit. It’s in the following format:
>
>     $MAX $PERIOD
>
>     which indicates that the group may consume upto $MAX in each $PERIOD duration. “max” for $MAX indicates no limit. If only one number is written, $MAX is updated.
>
"the group may consume upto $MAX in each $PERIOD duration". But $MAX what? Microseconds? Clock cycles? Arbitrary CPU scheduling units with only a relative meaning? Elephants? At the moment I don't know what values are sensible to set here.

I found the scheduler docs (https://www.kernel.org/doc/html/latest/scheduler/sched-bwc.html#management) which describe what sounds like might be a similar mechanism but for cgroup v1 - is this the same (in which case $MAX would in fact be measured in microseconds)?

Unless I'm missing something, I think the documentation should be updated to include the answer.

Thanks,

Patrick Reader

(I hope this is an appropriate forum to ask in - please direct me elsewhere if necessary).

