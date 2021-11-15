From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v8 5/6] cgroup/cpuset: Update description of
 cpuset.cpus.partition in cgroup-v2.rst
Date: Mon, 15 Nov 2021 10:11:47 -1000
Message-ID: <YZK/A43T+zvu89dl@slm.duckdns.org>
References: <20211018143619.205065-1-longman@redhat.com>
 <20211018143619.205065-6-longman@redhat.com>
 <20211115193122.GA16798@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=oBGYRkWYdG5WWKlBVnjVyKfV04QfW8RGDK164b+TnA4=;
        b=LxH3FSerOz2L4FFx8lOOBlj5sDebiEU7bdQ78fpem8rYkFkIwKt5lahlCizi4TTF4P
         VTs2qdZ7z5qxOaw7+EF9s5ZQDtxw/RGxj5lZY+KSMkC1AQd6K2EbCjmFhZ4ocqCGHGOb
         9i8Mts523tK+s/SCBSnuYNuvroDWi4X/q2lI8nbpcoOjE9B7ggNCCCILmNcZAPRa8hER
         pbwfvpEsASm/U5Qj6kF7DBMmZZe7YMxar375ZhNDdGQw9prl0zjDy9RFx5Bnolf1XIwP
         e6BbZOgECPQK0GP30XfIgGS9IherX0cM+mOZZspbp1kcKU+dG0bkbBLPX4q+xOu4o1E5
         PivA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20211115193122.GA16798-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Hello,

On Mon, Nov 15, 2021 at 08:31:22PM +0100, Michal Koutn=FD wrote:
> Now to the constraints and partition setups. I think it's useful to have
> a model with which the implementation can be compared with.
> I tried to condense some "simple rules" from the descriptions you posted
> in v8 plus your response to my remarks in v7 [2]. These should only be
> the "validity conditions", not "transition conditions".

FWIW, my opinion is pretty much in line with Michal's in this regard. Other
than that, everything looks pretty good to me.

Thanks.

--=20
tejun
