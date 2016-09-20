From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v1] cgroup,bpf: Add access check for cgroup_get_from_fd()
Date: Tue, 20 Sep 2016 12:58:17 -0400
Message-ID: <20160920165817.GB17513@htj.duckdns.org>
References: <20160919224913.24808-1-mic@digikod.net>
 <20160920003007.GB91808@ast-mbp.thefacebook.com>
 <57E1698F.1090106@digikod.net>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=h4ggeQw78imEXfEqaReD0C+MHPy6U0Wm9BH33tcLLig=;
        b=a62IduV/aD81XtKHZr6ZP4w3tJDjdOyPHQkOm5to5WQ+r39o2ajA3tckPKWHtIb5ZG
         q3YNNN9+e+96usZ+Sjx7i6G5RtDStCMrfLe74GTMe/yHOeLuuxvO06WefeCvDot5xrtM
         SGLPuZRdt5DjVI+bzFNKTnylVgxRrzjdIPj+t7pAFPiZc9nYKjrk3fZwDlmVbLMNCl7W
         xqvfDIn5tSO3g6ZzMT8lpA8jtuuHIQEz/0dUNyO34ka8woz026SiUDeZaJtkZZytRx/P
         rFDPpLtUiuVh+zlxiQGGSXmOJ2d8xqNvdJ2X497Fq8DkL7V8ZizP6YBW9sz7LPsISEtf
         VYYw==
Content-Disposition: inline
In-Reply-To: <57E1698F.1090106@digikod.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>, linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>, Andy Lutomirski <luto@amacapital.net>, Daniel Borkmann <daniel@iogearbox.net>, Daniel Mack <daniel@zonque.org>, "David S . Miller" <davem@davemloft.net>, James Morris <james.l.morris@oracle.com>, Kees Cook <keescook@chromium.org>, Martin KaFai Lau <kafai@fb.com>, cgroups@vger.kernel.org

On Tue, Sep 20, 2016 at 06:53:35PM +0200, Micka=EBl Sala=FCn wrote:
>=20
> On 20/09/2016 02:30, Alexei Starovoitov wrote:
> > On Tue, Sep 20, 2016 at 12:49:13AM +0200, Micka=EBl Sala=FCn wrote:
> >> Add security access check for cgroup backed FD. The "cgroup.procs" file
> >> of the corresponding cgroup should be readable to identify the cgroup,
> >> and writable to prove that the current process can manage this cgroup
> >> (e.g. through delegation). This is similar to the check done by
> >> cgroup_procs_write_permission().
> >>
> >> Fixes: 4ed8ec521ed5 ("cgroup: bpf: Add BPF_MAP_TYPE_CGROUP_ARRAY")
> >=20
> > I don't understand what 'fixes' is about.
> > Looks like new feature or tightening?
> > Since cgroup was opened by the process and it got an fd,
> > it had an access, so extra check here looks unnecessary.
>=20
> It may not be a "fix", but this patch tighten the access control. The
> current cgroup_get_from_fd() only rely on the access check done on the
> passed FD. However, this FD come from a cgroup directory, not a
> "cgroup.procs" (in this directory). The "cgroup.procs" is used for
> cgroup delegation by cgroup_procs_write_permission(). Checking
> "cgroup.procs" is then more consistent with access checks done by other
> part of the cgroup code. Being able to open a cgroup directory only
> means that the current process is able to list the cgroup hierarchy, not
> necessarily to list the tasks in this cgroups.

Currently, bpf's access control and cgroup's are completely separate
and intentionally so.  I don't see why this matters given the current
model.

Thanks.

--=20
tejun
