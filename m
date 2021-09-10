From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH 3/3] misc_cgroup: remove error log to avoid log flood
Date: Fri, 10 Sep 2021 07:19:43 -1000
Message-ID: <YTuTr5Hw4hPIWepd@slm.duckdns.org>
References: <86e89df640f2b4a65dd77bdbab8152fa8e8f5bf1.1631077837.git.brookxu@tencent.com>
 <20210909143720.GA14709@blackbody.suse.cz>
 <CAHVum0ffLr+MsF0O+yEWKcdpR0J0TQx6GdDxeZFZY7utZT8=KA@mail.gmail.com>
 <YTpY0G3+IJYmGbdd@blackbook>
 <478e986c-bc69-62b8-936e-5b075f9270b4@gmail.com>
 <20210910092310.GA18084@blackbody.suse.cz>
 <1679f995-5a6f-11b8-7870-54318db07d0d@gmail.com>
 <20210910153609.GC24156@blackbody.suse.cz>
 <YTuH9fULTx+pLuuH@slm.duckdns.org>
 <CAHVum0ezWW=4x2YgXHhEUFQOkFGBpP+R1Uc-KedHr+r0LGibwA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=02ZeBZU29R1KVCqeFtK2ESzdkVxQ2Opf6evacdtFUxc=;
        b=jl8XqBWfp5XyTB7oUD+ZWxcBGzhuAaxwldfYoiqmwmuu7Q0tAtyjae8AMreWOPvW0s
         utgdOKweJtvVQcMTuQ860R6K3q7BZQo0LJTzsQVnaQvtYdiETNccC5381EUxPVRlJlA6
         jPx4X7/7G8WVSG0iCUHBUCEUsDbi4iT0tEMDPmmuyWch7/8OgT3uCyodv2A7qlFXBLY+
         /bM/jU2Uo3q/m02kK2akuucklj/Utk2fFTD5NhE2h9E4qrhZdZ4QKIHqwOTF0lQIjUAL
         kRpdxSfJqTzxYKGCgk3MimG/MHNoTxEHF8ARtzieLsNFAMi8d3kqQYWjgrr4zftGIHr5
         jBog==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAHVum0ezWW=4x2YgXHhEUFQOkFGBpP+R1Uc-KedHr+r0LGibwA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, "brookxu.cn" <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Fri, Sep 10, 2021 at 10:16:46AM -0700, Vipin Sharma wrote:
> For now, I think we can just have one file, events.local
> (non-hierarchical) which has %s.max type entries. This will tell us
> which cgroup is under pressure and I believe this is helpful.

How about just sticking with hierarchical events? Do you see a lot of
downsides with that compared to .local?

Thanks.

-- 
tejun
