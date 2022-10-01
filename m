From: Jiri Olsa <olsajiri-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] perf stat: Support old kernels for bperf cgroup counting
Date: Sat, 1 Oct 2022 15:57:54 +0200
Message-ID: <YzhHYiTZf45dEWn0@krava>
References: <CAM9d7cjQ20a01YoZi=o-_7HT6TzR0TZgtpscKNvRrMq2yqV1Og@mail.gmail.com>
 <20220922041435.709119-1-namhyung@kernel.org>
 <YzdjHenrJpooKMjv@krava>
 <CAM9d7cjKaZvWQUwGwoTLNzAgHS7ndL_V_5+O+WqMUvuHJ7cWNg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date;
        bh=S6dQsVfxGBhLNZzfxTxMcZmUo50zQik/XnIunjEq2WM=;
        b=pFReg0bTnNJkev/4BKPuiVH6oyC8lSX9zxw9HhBaHcGwAC8ucCHnRGecOvrhrS0M1Q
         2CjU+x9UhxVWJqGk8bY4wYE8rB80j9QW9gQ1lSXT+nLwxggdZprZUmrP78grsh79jL8Q
         5GwhwQ3MqfHd+eIdp47w7DXwqtCp6GBB3Qf1ox5ungEAkszk0nSwqE9apK26gw8eQhSV
         aj5DZD7SgSQ9o0YI2iuwzWZy+mra7/BbMZGOtm6TAFqFnDV9s7KwOrrUJa7a/N+sU0NU
         VcN4idox4DaIe+AvlpUsjM/pTRRtkeuOS8fMd0TU/lBK3EgylhermRQKD9JHX8pKHkSd
         al3g==
Content-Disposition: inline
In-Reply-To: <CAM9d7cjKaZvWQUwGwoTLNzAgHS7ndL_V_5+O+WqMUvuHJ7cWNg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jiri Olsa <olsajiri-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-perf-users <linux-perf-users-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, bpf <bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Sep 30, 2022 at 02:56:40PM -0700, Namhyung Kim wrote:
> Hi Jiri,
> 
> On Fri, Sep 30, 2022 at 2:44 PM Jiri Olsa <olsajiri-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> > On Wed, Sep 21, 2022 at 09:14:35PM -0700, Namhyung Kim wrote:
> > > The recent change in the cgroup will break the backward compatiblity in
> > > the BPF program.  It should support both old and new kernels using BPF
> > > CO-RE technique.
> > >
> > > Like the task_struct->__state handling in the offcpu analysis, we can
> > > check the field name in the cgroup struct.
> > >
> > > Signed-off-by: Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > > ---
> > > Arnaldo, I think this should go through the cgroup tree since it depends
> > > on the earlier change there.  I don't think it'd conflict with other
> > > perf changes but please let me know if you see any trouble, thanks!
> >
> > could you please paste the cgroup tree link?
> 
> Do you mean this?
> 
>   https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git

yea, wanted to try that.. I cherry-picked the 7f203bc89eb6 ;-)

thanks,
jirka

> 
> Thanks,.
> Namhyung
