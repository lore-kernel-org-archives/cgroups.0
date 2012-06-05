From: Daniel Farina <daniel-Vgi1d2+GxVTQT0dZR+AlfA@public.gmane.org>
Subject: Getting malloc to return NULL under memory pressure
Date: Tue, 5 Jun 2012 15:08:08 -0700
Message-ID: <CAAZKuFYqDRvvqBXYhytXvXSk_Lp07o5bYGasy3A2aCK7ttG-hA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello List,

I'm here to ask about memcg, low-memory conditions, OOM, and getting
malloc to be able to return NULL in low-memory situations.  The
context follows:

I've been experimenting with some very-tiny PostgreSQL databases
inside of memory control groups (~hundreds of megabytes) and at the
lower end of my testing I noticed that out-of-memory conditions in
memcg seem to cause the OOM killer to trigger.

This was surprising because the non-memcg containerized versions have
overcommit turned off, and when not using memcg that results in malloc
returning NULL when the system is out of memory, which allows
PostgreSQL to abort the transaction and give an error message.  This
is a desirable behavior.  By comparison, OOM killing any child process
will cause the database to enter crash recovery and restart.  That is
not so desirable.

After doing some more digging, I learned from some mailing list posts
in around 2008-2009 that disabling overcommit doesn't have the
analogous effect in a cgroup as it does normally in Linux (in fact, it
would appear to do nothing).  However, I couldn't find any evidence
that this line of discussion had continued in a substantial way after
those postings, so here I am.  I'd like to know:

* Is there some mechanism by which I can make malloc return NULL in
low-memory situations
* If not, what would someone need to do to make this happen and get this merged?

Cheers.

-- 
fdr
