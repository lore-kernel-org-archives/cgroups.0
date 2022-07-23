From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3 cgroup/for-5.20] cgroup: Make !percpu
 threadgroup_rwsem operations optional
Date: Fri, 22 Jul 2022 19:12:07 -1000
Message-ID: <YtuDJ7DijEEy3PfS@slm.duckdns.org>
References: <YtDvN0wJ6CKaEPN8@slm.duckdns.org>
 <YtDvU4jRPSsarcNp@slm.duckdns.org>
 <YtDvl7Qjc5zI3e/b@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vQfcrjLQfJsHyJARxdU3O2zsQqRoNOwqh6fsHaYV9SA=;
        b=WD63DTaXf4JL2gAONMBONT0m5CXaWi5ga05M8g23sp9GgXRD4ohr4/mB9b5nyuKjVU
         9/voD4gn+EsXbKbNZ9GixOR/zzQw0i6b5CMeeEHM8bAn90lsiBxnK58nTttW8U88/q4T
         SUZE+IuFRbR7XlLpa5KAySMiHGQhNdY661OhQBnNTvwTDTet2/o3eP0gZPU+IIEXVbOx
         hGTnippenOJiJkAdOJfN30E26pDGRdb1MrfndfSDxMyA4TpSa1EFcO5l46SQCLFZB9we
         kOFpvKQVAMzQykhPDydAvQ8yE2P9Uzpajju0qpp0fI1qOphFUzXGaeqA+XSQyw1z9B2w
         EbcA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <YtDvl7Qjc5zI3e/b@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dmitry Shmidt <dimitrysh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Applying 1-3 to cgroup/for-5.20.

Thanks.

-- 
tejun
