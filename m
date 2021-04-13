From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/2] Relax cpuset validation for cgroup v2
Date: Tue, 13 Apr 2021 07:10:44 -0400
Message-ID: <YHV8NGTQ480UM+Yh@slm.duckdns.org>
References: <20210413090235.1903026-1-odin@uged.al>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OYmW1UnxxT4rnJ2/1wILvNuSFEnTONzHbfLCHY3gbcc=;
        b=q1ERVVWAx8ubOeUPgRemTV8yO1ywDCn6T6+7Fpn0bEZLD/ykqlxQa4cx5qhKoLFWah
         9jEY39DodaVFGzguLL6/qtozNbo0KhNSiAzuofUrRZdUoTEHN0MRBxc+1b07Fsq8Atf7
         Bx7V1si+Tv0Z7WPHcxv64OOElRaYVNjapC0p2hFSYerXzPcOm/bkiW+kqa8LOQR43wqp
         MZa7lCiDECwiedicR8vDlu5bv/9M/4/dAR6m0Ww/bGGzSw2hEKw7K7pKszV+ToyAmGzL
         QgEbkKpswzBAQxAJDbnPpBXl2fQnNq5nwV19Y/CURlwAvu6l2pmR/Sau81u+5vqd5N1v
         sMcg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20210413090235.1903026-1-odin-RObV4cXtwVA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Apr 13, 2021 at 11:02:33AM +0200, Odin Ugedal wrote:
> Two small validation relaxations for cgroup v2, making it easier to
> manage the hierarchy without the current pain points. Both changes
> work for both mems and cpus (but I have no NUMA machine to test mems).
> 
> Hopefully the patches has an ok description about what change they
> provide, and why they are helpful.

I'm generally in favor of removing configuration constraints but let's hear
what Li thinks.

Thanks.

-- 
tejun
