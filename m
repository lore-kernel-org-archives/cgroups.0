From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3 cgroup/for-3.19] cgroup: implement cgroup_get_e_css()
Date: Tue, 18 Nov 2014 02:50:58 -0500
Message-ID: <20141118075058.GB7809@htj.dyndns.org>
References: <20141117205652.GA23126@htj.dyndns.org>
 <20141117205734.GB23126@htj.dyndns.org>
 <20141117205855.GC23126@htj.dyndns.org>
 <546AE8A9.1090600@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Jg3nE7nFEJQX7fRlmQHW27HSxuXn+IJVVdvemQ3CEjE=;
        b=tJD5VtQf9N+RNhGfRCsOKuc+NaSd/69k17hMtBz9JJ7+90PBGgsvSy4uxy+KR5mUTM
         HsBD0QFBQMp8VbzTpEZOReginT6bTvQZYM+E+K0OU9/XJNt9KU3OkXtR7kzT6Y4UiFCD
         R5Y3yDyTiYe7LMUb9jK94oEwWLPVOiI4CqDZn0KI06kjxUM58J5IB3nIGf3jSoq38d7m
         tCnXFsCaB0LUm6I7lEhF6JkfCu/Z4avB2UVaZteIKieVKbxkp7JNR/RN+p2RceEMKq8s
         qfpfcxxc8nBKYI0oMFoMzudaxINy7yf8emuhvW560ZyfVwOM793wmC4frDglgU5D8DVy
         T93Q==
Content-Disposition: inline
In-Reply-To: <546AE8A9.1090600-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Nov 18, 2014 at 02:35:21PM +0800, Zefan Li wrote:
> For all 3 patches:
> 
> Acked-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied 1-3 to cgroup/for-3.19.

Thanks.

-- 
tejun
