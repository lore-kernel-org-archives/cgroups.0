From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 4/4] cgroup/bpf: Honor cgroup NS in cgroup_iter for
 ancestors
Date: Mon, 29 Aug 2022 07:49:27 -1000
Message-ID: <Ywz8J70t3508J62n@slm.duckdns.org>
References: <20220826165238.30915-1-mkoutny@suse.com>
 <20220826165238.30915-5-mkoutny@suse.com>
 <CAJD7tkZZ6j6mPfwwFDy_ModYux5447HFP=oPwa6MFA_NYAZ9-g@mail.gmail.com>
 <20220829125957.GB3579@blackbody.suse.cz>
 <CAJD7tkZySzWgJgp4xbkpSstc_RMN_tJqt83-FFrxv6jASeg8CA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=GldkU/h9E+n5JOZ7ToIB/cVKuwIFqjSjpJq/es1t7Xg=;
        b=fB9q9zF4XqP67FyYM7Iv61AuQ77MaSzVus59AWlWVNi5fpF0a9f9QzJmqNJwL7faef
         22Q5q/tee/SwfCuIQyXbGg+5yJnEN8+CrdPZn6TQDlHlYR0BvIxSFbdkGlz9hIIIBGyt
         KifX/c5l4CyZ/Dgq/QpM1ggDc9JJqgNBmJ4HURCNWw9hP1fo3c3FR8AcPSv4+DMhrOUh
         jFigQEPQ5HFlAzq2G3kZQ8eok85E/Q6aDq37F1zJvwKO9B9e9aOUQksXqA6F1Fk4q6+c
         UNYutjitCES3kEp7ag91ULXSFJHjTGaXQGDIKleERmQ5sp0sj8U4o4xLbHfDnA6UD9r4
         5Tag==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <CAJD7tkZySzWgJgp4xbkpSstc_RMN_tJqt83-FFrxv6jASeg8CA@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Aditya Kali <adityakali@google.com>, Serge Hallyn <serge.hallyn@canonical.com>, Roman Gushchin <roman.gushchin@linux.dev>, Yonghong Song <yhs@fb.com>, Muneendra Kumar <muneendra.kumar@broadcom.com>, Hao Luo <haoluo@google.com>

On Mon, Aug 29, 2022 at 10:30:45AM -0700, Yosry Ahmed wrote:
> > I'd like to clarify, if a process A in a broad cgroup ns sets up a BPF
> > cgroup iterator, exposes it via bpffs and than a process B in a narrowed
> > cgroup ns (which excludes the origin cgroup) wants to traverse the
> > iterator, should it fail straight ahead (regardless of iter order)?
> > The alternative would be to allow self-dereference but prohibit any
> > iterator moves (regardless of order).
> >
> 
> imo it should fail straight ahead, but maybe others (Tejun? Hao?) have
> other opinions here.

Yeah, I'd prefer it to fail right away as that's simple and gives us the
most choices for the future.

Thanks.

-- 
tejun
