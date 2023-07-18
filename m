From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup/misc: update struct members descriptions
Date: Tue, 18 Jul 2023 12:03:46 -1000
Message-ID: <ZLcMQiHnrkptxw8Q@slm.duckdns.org>
References: <20230718090834.1829191-1-kamalesh.babulal@oracle.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689717828; x=1692309828;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FR+6E9FyZxtez1dGS44CZnCU/J8novnbxJHJ/pWrifY=;
        b=T5EhxnRXBSA7LDQpQiVg3BdYf/rybxuzpOdRyouCElvPFosDcNy7erdqXQ8E/EoWc1
         XORYYUp4WziozuqO980Vj0N1N3z6YXgrrNNIqzVxU99CZJI0AriyiJS40o41t+GG99eX
         QzzjbcmJRL/Il4EBULf5EktEhyjYyEXKCkn/g4IpiGWHAFjr7h+cIQEf2YgZ8EOABfaw
         U19EOVHLry9io77aGzkvdEMnfZIDFLkLkiWoUnIXYwB/3fdN7t1f5tcaEz+c88VPBnRI
         pl/jpm92kgR2L8o5ynFpK2FjSoG54rEEwP8TPqfi1Tx+TcLRhe9UFWc/9uMEB3OC8YCo
         ouEQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230718090834.1829191-1-kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kamalesh Babulal <kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tom Hromatka <tom.hromatka-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Jul 18, 2023 at 02:38:34PM +0530, Kamalesh Babulal wrote:
> Update the miscellaneous controller's structure member's description of
> struct misc_res and struct misc_cg.
> 
> Signed-off-by: Kamalesh Babulal <kamalesh.babulal-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-6.6.

Thanks.

-- 
tejun
