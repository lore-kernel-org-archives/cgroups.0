From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: Prevent double killing of css when enabling
 threaded cgroup
Date: Wed, 15 Jan 2020 08:07:46 -0800
Message-ID: <20200115160746.GG2677547@devbig004.ftw2.facebook.com>
References: <20191219022716.o7vxxia6o67tyfmf@wittgenstein>
 <20200109150559.14457-1-mkoutny@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=zSIfSAzXaUnmeHj5yAo3f8W68OERKqDK+WA3I8DQXME=;
        b=djnWz5Uv5uxqmn8ZPz8gXmpXymRwdVRfn2Ka203Vjcor3GCoGHr4bsAzTivzjFgh6U
         qt/PLBVgXNj39rkovMYAxr5MF2wYd7D1+Yjilxz02n8uXjasXFbCy4q2YPMX0PGg9Q7v
         AFifPDmKFtqeQ5zKZkysF5IAlIlXIeTd/hR03AhLB7eM7sj1erDyBl6wQXZRkYGb04Qc
         bbJD7lp2zBvZqlWNllNjM1DJCYEHr14B0QQmorF72OTclYQWbKGU8GwceQF01uoCFeuJ
         PyGvhCAJEeDDu1VnZ2Dtc4Q53lNCP8LEMHDLfgq8EWFk/DBWB8cK2hTbyI/Ixct35Pyg
         iNxA==
Content-Disposition: inline
In-Reply-To: <20200109150559.14457-1-mkoutny-IBi9RG/b67k@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>

On Thu, Jan 09, 2020 at 04:05:59PM +0100, Michal Koutn=FD wrote:
> The commit prevents these situations by making cgroup_type_write wait
> for all dying csses to go away before re-applying subtree controls.
> When at it, the locations of WARN_ON_ONCE calls are moved so that
> warning is triggered only when we are about to misuse the dying css.

Applied to cgroup/for-5.6.

Thanks.

--=20
tejun
