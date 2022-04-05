From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: Wrapper to run a command in a temporary cgroup
Date: Tue, 5 Apr 2022 13:27:43 +0200
Message-ID: <20220405112743.GC13806@blackbody.suse.cz>
References: <0174490d-8679-3885-df31-e9f6c1e7205b@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1649158064; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=S4RYhhYYgL2nQUXq/1MYpaBKBxeBnU3Dj31ERHGSis8=;
        b=qtPQqZC1moA5TLgAvs7AZe9Ksa/HPjEqpo3mBs5dL2NYE66pYPmmw3R9brwHzd4EtNSzZY
        0aSQsTeOmrOeLCMddapTYRluiqgu411jHFwFT1TZrgu6X03epsdtSmYOIj2GYEcKR/QTBS
        RagW8WedBfSTyebZ0lMgh+uNP88yk1k=
Content-Disposition: inline
In-Reply-To: <0174490d-8679-3885-df31-e9f6c1e7205b-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "R. Diez" <rdiez1999-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello.

On Mon, Apr 04, 2022 at 02:25:27PM +0200, "R. Diez" <rdiez1999-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> run-on-temporary-cgroup.sh cmd arg1 ... argn.
> 
> The tool should create a temporary cgroup, run the process inside, and
> return the same exit code as the user command.

This sounds very much like `systemd-run --scope`.

> Those requirements are similar to what systemd-run does, but I need an
> alternative which does not depend on systemd.

Fair enough.

> Even if you have systemd, systemd-run is rather convenient, but it is
> somewhat heavy weight 

Then a suggestion of using a container runtime is likely out of question
too.

> If there is no such a tool, can someone give me some hints on how to
> implement one? Is it possible in Shell or Perl? Or do I need to reach
> to C / C++? Is there anything similar I could take as basis?

There's also libcg [1] (whose cgroup v2 support is WIP AFAIK) with its
cgexec utility. I don't know other tools (besides the named previously).

You can implement it in whatever environment that can interact with
filesystem (and perhaps poll for events), it's all documented in [2]
(alternatively [3], which I'd discourage for a new project).

HTH,
Michal

[1] https://github.com/libcgroup/libcgroup/blob/main/README
[2] https://www.kernel.org/doc/html/latest/admin-guide/cgroup-v2.html
[3] https://www.kernel.org/doc/html/latest/admin-guide/cgroup-v1/cgroups.html

