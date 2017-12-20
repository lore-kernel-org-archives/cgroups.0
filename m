From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Cgroups v2 thread mode "domain invalid" state
Date: Wed, 20 Dec 2017 21:32:04 +0100
Message-ID: <CAKgNAkg2u=zt87tKk35vR+tQ7DnkJp9vbj+8n88=_MCcvmH9oQ@mail.gmail.com>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to:cc;
        bh=/dyyCL26+qhVwCrfKbbwFVR9ltE1ZSv8f2Jf8Fr9wzQ=;
        b=XDqjqP1lNoq/GR609P0UiS/W2RY3UEF+HOnoFsWsYpZlI2cYn6iOFo4vTgoi9JKXm6
         caIgRTubfb2JJ/UcywexWn8H65byfvD+3GY5kGJjgpJcsIKLlfKZP9iksTFoVqEMNRYp
         lreiHjktmVyyDR0XWgNGJZloQH3IN6/V6pehsS9G3+JWzr2mLbL5GPOj0/qKhvow+q96
         ggNf1bXN1z+9pz+g8h7dzUDUocUyvCHjtXuwsUGPH1os1PZ1H2CSmcwn6BJesViChZf1
         bukiTPSPLJcrQiQqBQsmhPGhbhRxhRM27r67sSSHRUDoP3h0gu/sZAbXFqhJd/VbSwhw
         e00w==
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-man <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello Tejun,

At some point, I'd like to add some details about cgroups v2 "thread
mode" to the cgroup(7) manual page. I think I understand most of the
details by now, but there's one question I still can't work out an
answer to: why does the "domain invalid" cgroup type exist?

I did find the July 2017 mail thread
"[PATCH 5/6] cgroup: implement cgroup v2 thread support"
(https://marc.info/?t=150025735500001&r=1&w=2)
where this cgroup type was discussed, but I must admit that I still
don't get it. Instead of converting cgroups under a threaded subtree
to "domain invalid" type, why can't they just be turned straight into
"threaded" type?

I guess another way of asking this question is: what possibilities
does manually switching each "domain invalid" cgroup to "threaded"
allow that wouldn't be allowed by immediately making all of the
cgroups in a threaded subtree "threaded"?

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
