From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH bpf-next v4 3/3] bpf: remove the cgroup -> bpf header
 dependecy
Date: Wed, 15 Dec 2021 08:28:39 -1000
Message-ID: <Yboz17Cd3NrdircO@slm.duckdns.org>
References: <20211215181231.1053479-1-kuba@kernel.org>
 <20211215181231.1053479-4-kuba@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=a9xKB7125uY8kvHBhF0BhgO3Irg0Ekzdpi8lSoaB3TU=;
        b=CzxiwAxOnRR49YKD5qgwaxrwRc7E6+GE1H/V6hV55mvovKfwUDglOhPkTSxG/bPWyx
         f1dy6m1pSoAqHSC19ACg+Nm2LZrL7y1EOt105wfURgewtPi2sFVOG4di3yocH26zo0Rp
         3CUlDHSyIxrB8yXASXHxzCRH8h6aMpRMbyJIDlVxeB6tnbZSfu/tbGOgfHqKtlppcACl
         dY4aJcoZTt2RuFkFdOSX+L14PZdS36Tw1Z+EygnsRF30BUe2saYDD9aRDXjRAhitDKDt
         rY0w3veSgYUdpcuMh8iRqCMsYlgstAUIfHlns1cHA4vksVynPV6n3r6OJPLX1lOU2HHl
         70EQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20211215181231.1053479-4-kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org, ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kafai-b10kYP2dOMg@public.gmane.org, songliubraving-b10kYP2dOMg@public.gmane.org, yhs-b10kYP2dOMg@public.gmane.org, john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Dec 15, 2021 at 10:12:31AM -0800, Jakub Kicinski wrote:
> Remove the dependency from cgroup-defs.h to bpf-cgroup.h and bpf.h.
> This reduces the incremental build size of x86 allmodconfig after
> bpf.h was touched from ~17k objects rebuilt to ~5k objects.
> bpf.h is 2.2kLoC and is modified relatively often.
> 
> We need a new header with just the definition of struct cgroup_bpf
> and enum cgroup_bpf_attach_type, this is akin to cgroup-defs.h.
> 
> Signed-off-by: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
