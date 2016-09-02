From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Why would cpu cgroup get disabled by the kernel?
Date: Fri, 2 Sep 2016 09:29:43 -0400
Message-ID: <20160902132943.GE12660@htj.duckdns.org>
References: <CAGmahrS4P7kS6_5MOhHA=ge6mcq0C2f85iN9S3z5dgi+qsEh9g@mail.gmail.com>
 <9B0331B6EBBD0E4684FBFAEDA55776F92CE0E032@HASMSX110.ger.corp.intel.com>
 <57C94D7E.4090204@huawei.com>
 <CAGmahrTwRC3cr72S2sJC9pzCxuGmYeWHe-iprz9D20DDDvU7MA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5KCfaHmckXTzf2rtLSjX/ISDXRcZvFTd5xlHnKLj+Zo=;
        b=zMY5oKKDZ/yCNL9noCw5zJJIjIj2Nd/wL3QgZbYzAKFyT2t2AogD7MS8RT/QNrMcnx
         OgpkE2I0xbitYi6q1BqP1+i7cltDDF7jIxgwtuer+sngnt0lN5tlSvlv6xs8HeN1dHP9
         fO0umx5VBI6W+f7H5Teq8CswarfI8V9N+6Nx17KglFVEjVdU1I0ahKY/bK7BwhPpm+Bx
         N4qTsZaI4iPBdFDyJCGAMLajoM/I0rA+R1Bm84LSBeirPDb7FWjJZ81RspH5LSVjBA0R
         GGznKaZaRixM7CZcZS4qB6i22AFO77sNJZnfV4La3EHhjca6oHVng20s1JdW1a1NMiGT
         IwCQ==
Content-Disposition: inline
In-Reply-To: <CAGmahrTwRC3cr72S2sJC9pzCxuGmYeWHe-iprz9D20DDDvU7MA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sverd Johnsen <sverd.johnsen-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Cc: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Rosen, Rami" <rami.rosen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Sep 02, 2016 at 01:49:44PM +0200, Sverd Johnsen wrote:
> /proc/cmdline and CONFIG_CMDLINE are just the standard options (root
> console etc.), nothing regarging cgroups. cgroup_disable does not get
> used anywhere..dont you think I would have thought of that.

Everyone makes silly mistakes and your reputation of immunity isn't a
general knoweldge.  Don't be snippy with people trying to help you.

Li is right that that message can only be triggered by
cgroup_disable_mask which can only be set through "cgroup_disable="
kernel boot parameter.

* Attach full dmesg after a problematic boot.

* If you can, add printk of cgroup_disable_mask in cgroup_init() and
  see what the value is.

-- 
tejun
