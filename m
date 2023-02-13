From: Victor Stewart <v@nametag.social>
Subject: [BUG ?]: hugetlb.xxx[.rsvd].max implicit write failure
Date: Mon, 13 Feb 2023 00:34:02 +0000
Message-ID: <CAM1kxwgN40r3tqdUFXPNgSAB3djMTDpDAXOACsS2zOF=LXxeyw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nametag.social; s=google;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=LxA1TCaBk0GL+z3/VOAYiE8xj7jmKbbc+ETm8+jDUgU=;
        b=KjXI8TpYcB7UD4vda6gQOkHeiQ4OFGAzfFk5l6Gm7duO8dyZlqWIhfz2tWFRHFgIk0
         08Zps9JGkKuEMBGwt82tOpXYB0K2oT6QEf4YDHbCfyTizO76atpgcGRV1hNYwpe2XKVS
         WzoZql8vdSoHxWLP/0eH5qjkRZp9+Gey3+AvM/XxBmOtwpEibaxVOQ3hsAiJlK7cZ8nf
         qt9GyG4yiAeIZNEYatEZIj1N9qaMERIacAqK5pb4W1MV5fX34S3FMukm2iZonlNLwRMS
         fDrQfG48USrTgH7DAXotpIa8Q6oFEoY4VJz3fLB9mfz6/XV2Azwr0oJprxLm/goZo7L6
         RC2A==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

attempted to use hugetlb resource control for the first time. running 6.1.9

create the subdirectory, then enable the hugetlb controller. reading the
initial value of hugetlb.2MB.rsvd.max returns "max". i write 128 and receive a
return value of 3. but then read hugetlb.2MB.rsvd.max and it now returns 0.
same exact thing happens for hugetlb.2MB.max

so clearly the write is secretly failing somewhere even though the write
operation return success?

there are plenty of pages available:

HugePages_Total:    4096
HugePages_Free:     4096
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
Hugetlb:        13631488 kB

none of the scarce documentation on this controller leads me to believe there's
any required configuration beyond the above. so completely bewildered as to
what's going wrong?
