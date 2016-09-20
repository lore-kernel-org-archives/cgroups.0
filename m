From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v1] cgroup,bpf: Add access check for cgroup_get_from_fd()
Date: Tue, 20 Sep 2016 09:53:08 -0400
Message-ID: <20160920135308.GA17513@htj.duckdns.org>
References: <20160919224913.24808-1-mic@digikod.net>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=IdGivqvArXZntvjs0+TlkrC+yqsWCljXWa5fV5CviPc=;
        b=j80JSZVEM6E+ZYO6WOHLNEjFYKEsgiRvpI85GPXHF6v8C0PAZVTjG7KGEs6b+HKfVS
         kyVNEJ/YVax7vBr+wH6WhuU+ig8ZdKzgF458trdpOOusp12Js4oojau3lKTFp/2dQkx3
         2s6hmZpGXyLgX8FYKQGtXOoKrwWXii+v3UndQZnvjlaFZL94mGO7Zuxq49QSTdadiCCh
         5auTppynad2IpP+/VcZLAbdWyvLPwkbEW7kIw9xZ2Piowbg+Pq5kpkrQ3XqwtwV5UE+o
         djqtB0fBDli0r6xSCaarUwb9iUGnuoNqKMvMfyGszLQ1Esm6SlohZW8RnlXFkFMMMLma
         dk0w==
Content-Disposition: inline
In-Reply-To: <20160919224913.24808-1-mic-WFhQfpSGs3bR7s880joybQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic-WFhQfpSGs3bR7s880joybQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>, "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Tue, Sep 20, 2016 at 12:49:13AM +0200, Micka=EBl Sala=FCn wrote:
> Add security access check for cgroup backed FD. The "cgroup.procs" file
> of the corresponding cgroup should be readable to identify the cgroup,
> and writable to prove that the current process can manage this cgroup
> (e.g. through delegation). This is similar to the check done by
> cgroup_procs_write_permission().

Can you please explain why this change is beneficial?

Thanks.

--=20
tejun
