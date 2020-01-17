From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/3] cgroup: Iterate tasks that did not finish do_exit()
Date: Fri, 17 Jan 2020 09:28:06 -0800
Message-ID: <20200117172806.GK2677547@devbig004.ftw2.facebook.com>
References: <20200116043612.52782-1-surenb@google.com>
 <20200117151533.12381-1-mkoutny@suse.com>
 <20200117151533.12381-3-mkoutny@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=YJBe+PR1JTzkbV6VdX/ClFM8UuTfYuVGKNcb10Up+LM=;
        b=DbHiqO+e6kYuR6bMRUFqkRzJXzREnc/t8WeVUwNtwBq0US0ALqFtfBS3k8Ar5PzFae
         jpbiR7Ax+NvFzgNUZfzP6b4KBWdJJ8us7/sDH5Tiro8mnHYZM1bos9P/GDhAcxVHXG4b
         +CqRW+gbtb40Tq4JQ9+XfDuAtGc8xx7XWoPbLCDa9sXO0xSMc54OuWYlMPO3hMfg3xGs
         R6SRfw70eNBH9z1vinkvQf3Pkmv//DOGZzpDO/JeaaQZKfMlTJoC34/zqw6bnCacSApd
         hf6+skAgQQBrKH5W5od7c18HNBincCZTYsXdKlpO3ehhcjXZitzgNqPGCAFsoZlAoM4q
         MvUg==
Content-Disposition: inline
In-Reply-To: <20200117151533.12381-3-mkoutny-IBi9RG/b67k@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, linger.lee-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tomcherry-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

On Fri, Jan 17, 2020 at 04:15:32PM +0100, Michal Koutn=FD wrote:
> PF_EXITING is set earlier than actual removal from css_set when a task
> is exitting. This can confuse cgroup.procs readers who see no PF_EXITING
> tasks, however, rmdir is checking against css_set membership so it can
> transitionally fail with EBUSY.
>=20
> Fix this by listing tasks that weren't unlinked from css_set active
> lists.
> It may happen that other users of the task iterator (without
> CSS_TASK_ITER_PROCS) spot a PF_EXITING task before cgroup_exit(). This
> is equal to the state before commit c03cd7738a83 ("cgroup: Include dying
> leaders with live threads in PROCS iterations") but it may be reviewed
> later.

Yeah, this looks fine to me.  Any chance you can order this before the
clean up so that we can mark it for -stable.

Thanks.

--=20
tejun
