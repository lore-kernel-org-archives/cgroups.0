From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH 3/3] misc_cgroup: remove error log to avoid log flood
Date: Fri, 10 Sep 2021 07:37:44 -1000
Message-ID: <YTuX6Cpv1kg+DHmJ@slm.duckdns.org>
References: <CAHVum0ffLr+MsF0O+yEWKcdpR0J0TQx6GdDxeZFZY7utZT8=KA@mail.gmail.com>
 <YTpY0G3+IJYmGbdd@blackbook>
 <478e986c-bc69-62b8-936e-5b075f9270b4@gmail.com>
 <20210910092310.GA18084@blackbody.suse.cz>
 <1679f995-5a6f-11b8-7870-54318db07d0d@gmail.com>
 <20210910153609.GC24156@blackbody.suse.cz>
 <YTuH9fULTx+pLuuH@slm.duckdns.org>
 <CAHVum0ezWW=4x2YgXHhEUFQOkFGBpP+R1Uc-KedHr+r0LGibwA@mail.gmail.com>
 <YTuTr5Hw4hPIWepd@slm.duckdns.org>
 <CAHVum0e+68df7b_e0RoCGgA1h_SLdTt9t2MZ0VgA9afPW9iEvg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jL2YbilCduyWVuLH2nyWGfZ9AabnwMlBBSRytcjIHVA=;
        b=GgBEAjpyJudHJW1qXwmNtoQyZEkoV+deBT9s3t6hEcqTihdSKoJEvrP13wsSDQ40hA
         ZSn9iYRFxbjcu5jnWG7iujvujUDDXs82ys+0QLYnpH+D6ghZYdSu8ylk8Y1Y/WpKTavC
         c35/jfw/5cwmI20noQzrqxpRY0lENcALsrDY/AzTB13OSLbkpo4sABmnANkk6ZmJ9IbK
         9duYffwM7wGLWyZVdbP+krzQNNtgcKbnU+lq2GUdwb4iN8lhAQVjg2psAPXZ3Rnzab5U
         OB2j8Q2RUw1tqPt7uR4orpTvMBtmwroHwH4E4SniulU6kgOgJoZO8zc1moR3Vy52Sqn3
         4dLg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAHVum0e+68df7b_e0RoCGgA1h_SLdTt9t2MZ0VgA9afPW9iEvg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, "brookxu.cn" <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Fri, Sep 10, 2021 at 10:31:02AM -0700, Vipin Sharma wrote:
> I don't have a strong aversion to hierarchical events only as well if
> that is more suited for the cgroup v2 style.

It's not a hard requirement but I'd prefer hierarchical over local unless
there are strong reasons against doing so.

Thanks.

-- 
tejun
