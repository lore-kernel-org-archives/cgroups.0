From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: cgroups(7): documenting cgroup.stat
Date: Tue, 2 Jan 2018 19:22:33 +0100
Message-ID: <196c0cca-b573-8c65-2b5f-66376f79a836@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=cc:to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=tfeUmj6UlwAKk0qeKJVn1abIuKimVfJqicdLOD0DBmE=;
        b=Sc3zoHUDYknQ46EXSQmmYYH3ML5pjACJ84AFGmCeJB1QlTW+/kCBTMkjSETQxTHriN
         brm5MrbdnzEHNIA4952bQuVg2DnEPXYj5M7G5xhi36D3OUf1vtaK/pUWOkPFrY3LJqwO
         ZrNT7XYnY0b5hxD/nSckOKH56tC8e2uaehlgI2okSSkm60E02Wqe97Wip6gYXSefMShA
         1MU9yKnJHUedXSNuOtPyy9ZQHFf41d1NbsTAoN3ipQ4kJ5UiDoeFD5C5J4VkbNPo3Fc5
         iKz29yvUIRZOrahqeBIpY71VjjTtyxIBX5uSS1PTeeUksNrEcR1hoNwnK+3w9sov2g92
         1O4Q==
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello Roman,

I wish to add documentation to cgroups(7) for the cgroup.stat file
that you added in Linux 4.14. I wrote some text based on your text
added to the cgroup-v2.txt file, but added some pieces, and also have
a question (see below). The plain-text version for (easy review)
is shown below. Could you please review this text? (Please note 
the FIXME!)

The branch containing the pending cgroups(7) changes can be found at :
https://git.kernel.org/pub/scm/docs/man-pages/man-pages.git/log/?h=draft_cgroup_updates

[[
   Cgroups v2 cgroup.stat file
       Each   cgroup   in   the  v2  hierarchy  contains  a  read-only
       cgroup.stat file (first introduced in Linux 4.14) that consists
       of  lines  containing key-value pairs.  The following keys cur‐
       rently appear in this file:

       nr_descendants
              This is the  total  number  of  visible  (i.e.,  living)
              descendant cgroups underneath this cgroup.

              ┌─────────────────────────────────────────────────────┐
              │FIXME                                                │
              ├─────────────────────────────────────────────────────┤
              │For  the  following text on nr_dying_descendants, it │
              │would I think be  helpful  to  describe  a  condrete │
              │example of when one might see nr_dying_descendants a │
              │nonzero value for this  key.  Ideally,  the  example │
              │would be one that the reader could easily reproduce. │
              │Is there such an example?                            │
              └─────────────────────────────────────────────────────┘

       nr_dying_descendants
              This is the total number  of  dying  descendant  cgroups
              underneath this cgroup.  A cgroup enters the dying state
              after being deleted.  It remains in that  state  for  an
              undefined  period  (which  will  depend  on system load)
              before being destroyed.

              A process can't be made a member of a dying cgroup,  and
              a dying cgroup can't be brought back to life.
]]

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
