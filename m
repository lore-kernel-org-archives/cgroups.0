From: Kumar Kartikeya Dwivedi <memxor-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH bpf-next v1 2/5] cgroup: bpf: add cgroup_rstat_updated()
 and cgroup_rstat_flush() kfuncs
Date: Fri, 20 May 2022 15:06:07 +0530
Message-ID: <20220520093607.sadvim2igfde6x22@apollo.legion>
References: <20220520012133.1217211-1-yosryahmed@google.com>
 <20220520012133.1217211-3-yosryahmed@google.com>
 <YodCPWqZodr7Shnj@slm.duckdns.org>
 <CAJD7tkYDLc9irHLFROcYSg1shwCw+Stt5HTS08FW3ceQ5b8vqQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0c6tWWHaqv9YocEluVJeMxSaQ4ffT6xCHDnlxrPLBcE=;
        b=IvQ0zqSKhM4OPBa9NW2eBe3mL6oMzRwfVSXxibRyEnDg7sQiJOrnFMuGIUjkpXv1iG
         Fomrt61emOrTmIb11bduSCbpEE+y/l0zKOvlJ2p1EgpEY2tiFAiCjgBiDKYCl9pbsgI8
         D17DhLJjB1MxjhxyBT9Gm1EhgLhYiTK4srsjlRyVHfWcNrZcd5cG5arh7GSCqSV/X6z3
         9jReKVrkwiMg+7ubudidg5VZOUH5WVMpWkJ/5yfxEcwZOP64zVkVGkkDkFYtOyH/whj1
         jPS4I2G4sRp02+3P5Hq+1rGL+lKjRcS0BuYvw/IOIKcLpY0YoP/lDWfb/VJTTKPQsPiR
         9g8g==
Content-Disposition: inline
In-Reply-To: <CAJD7tkYDLc9irHLFROcYSg1shwCw+Stt5HTS08FW3ceQ5b8vqQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hao Luo <haoluo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Stanislav Fomichev <sdf-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Networking <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, May 20, 2022 at 02:43:03PM IST, Yosry Ahmed wrote:
> On Fri, May 20, 2022 at 12:24 AM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >
> > On Fri, May 20, 2022 at 01:21:30AM +0000, Yosry Ahmed wrote:
> > > Add cgroup_rstat_updated() and cgroup_rstat_flush() kfuncs to bpf
> > > tracing programs. bpf programs that make use of rstat can use these
> > > functions to inform rstat when they update stats for a cgroup, and when
> > > they need to flush the stats.
> > >
> > > Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> >
> > Do patch 1 and 2 need to be separate? Also, can you explain and comment why
> > it's __weak?
>
> I will squash them in the next version.
>
> As for the declaration, I took the __weak annotation from Alexei's
> reply to the previous version. I thought it had something to do with
> how fentry progs attach to functions with BTF and all.
> When I try the same code with a static noinline declaration instead,
> fentry attachment fails to find the BTF type ID of bpf_rstat_flush.
> When I try it with just noinline (without __weak), the fentry program
> attaches, but is never invoked. I tried looking at the attach code but
> I couldn't figure out why this happens.
>

With static noinline, the compiler will optimize away the function. With global
noinline, it can still optimize away the call site, but will keep the function
definition, so attach works. Therefore __weak is needed to ensure call is still
emitted. With GCC __attribute__((noipa)) might have been more appropritate, but
LLVM doesn't support it, so __weak is the next best thing supported by both with
the same side effect.

> In retrospect, I should have given this more thought. It would be
> great if Alexei could shed some light on this.
>
> >
> > Thanks.
>
>
> >
> > --
> > tejun
