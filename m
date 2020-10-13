From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: Remove unused mod_memcg_obj_state()
Date: Tue, 13 Oct 2020 09:35:53 -0700
Message-ID: <20201013163553.GA3754702@carbon.dhcp.thefacebook.com>
References: <20201013153504.92602-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : in-reply-to : mime-version :
 content-type : content-transfer-encoding; s=facebook;
 bh=IxPOCF1993S3QaPPdLtUzkCPBFxHymBIwLPrdYNgUZw=;
 b=ez3E8wTMo+8YusLEdFHMzSVj5HiKb17A+bdEYInP5J2LBW6HiJRoASajcHfLRIxEa9/9
 Gegw6eIh850DfRJYf3skFQGEdfybl9zq2UvbcqvxBlb9jBgxhZSe/6mJ1cIpmBmJK4e4
 BvVkVPXI2u49+H5gjqyv+wmsLjvuT5+HEB4= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IxPOCF1993S3QaPPdLtUzkCPBFxHymBIwLPrdYNgUZw=;
 b=TA5BHPbhHKDuivIXAhI0lykStClJyPHWeQ6Iip0U/pS0rC7tKevp8VTWipBCGRacqY3wQ2edC+T7Ny5KK+Hrhwrj6pdME/7Ig4zCGBJEn8by9d+FMAcYilgMXICpYcD2YBMyjSV0GEPoXHi8+xZnel1dNVy3PkHDSdHmkHHmHFQ=
In-Reply-To: <20201013153504.92602-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org, penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Tue, Oct 13, 2020 at 11:35:04PM +0800, Muchun Song wrote:
> Since commit:
> 
>   991e7673859e ("mm: memcontrol: account kernel stack per node")
> 
> There is no user of the mod_memcg_obj_state(). This patch just remove
> it. Also rework type of the idx parameter of the mod_objcg_state()
> from int to enum node_stat_item.
> 
> Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

Thanks!
