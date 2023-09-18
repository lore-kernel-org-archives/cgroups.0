From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v8 0/7] cgroup/cpuset: Support remote partitions
Date: Mon, 18 Sep 2023 10:33:06 -1000
Message-ID: <ZQi0AvvYJqaKkKG9@slm.duckdns.org>
References: <20230905133243.91107-1-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695069188; x=1695673988; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UEnHEVF0sQxeNUYZ0vdBfHCJqqJDyzd1BEi34ZYEm3U=;
        b=hMuQzLRkcNz/aszxtvzUu66z+V/pkZbL59f9lf8wALxgkUl+0BNRXJ4MTDxQQONGOy
         q479/s4OzLr6KbPsjTUB0+8uajOCR/5+Vgs1hyExvrfRlAgkPX9OX43IlZM25oA6mdjL
         FBHruqXSBxK91sPRIaKew6BuT4tjaKMjszy5YgvZhPWAyZEm8JUcm9ShpMAOvGoUZdo3
         yB9kpiLrSV8M6UszoaZmETWOHtCRh4Sqyyw+BlhYSk6fx5iJimJNFbuBlIfeU6wZ7gJt
         OyBpIuBnmK3Jj+cSQCTna5MHPEMl8HisVlAvXw0SsLthCm8vHC1XoL9G0az6J/mvZuCS
         mnDg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230905133243.91107-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Giuseppe Scrivano <gscrivan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Applied the series to cgroup/for-6.7.

Thanks.

-- 
tejun
