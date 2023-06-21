From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: remove obsolete comment on cgroup_on_dfl()
Date: Wed, 21 Jun 2023 09:00:16 -1000
Message-ID: <ZJNIwAJDibFthvwp@slm.duckdns.org>
References: <20230617074809.1929778-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687374019; x=1689966019;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zkWc31QshB/LMbmy/U7IMxynfJvynM10dLnhD7VuGr0=;
        b=hn4FLYsX9n/TfMXBqz5KHMRnQQPS9PO99wDb/S2cBdELnBET33B1yuvsV2X+R132Rl
         kS5U4v/nsxmTZBpS1ZlzPJ/V4eRwgZJ6gtt6FgjrgmdEcu5e9Qvlqt6p4E+sD6SXx0Hb
         Ds+wqYyxr7boTwr92KQQhIIlbp5oL4p4DAhTWGbrxkxfCUA0k/MVgftuJwyg0Xym2EBA
         XuLptxf8aH2v70DL98tpcQPRtfWoiHvEAkR0cAxTVvYlAVtkmhotPvZgAx2yPksVa9Nf
         zcC07SWEstZU5sQwiXngm8kNsVhHn0yBSMA4riraUtHDnbFn4Vfofe70985kCFS4Nw9g
         jr6A==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230617074809.1929778-1-linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, Jun 17, 2023 at 03:48:09PM +0800, Miaohe Lin wrote:
> The debug feature is supported since commit 8cc38fa7fa31 ("cgroup: make
> debug an implicit controller on cgroup2"), update corresponding comment.
> 
> Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-6.5.

thanks.

-- 
tejun
