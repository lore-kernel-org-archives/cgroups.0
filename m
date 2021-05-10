From: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
Subject: Re: [PATCH v3 1/5] cgroup: introduce cgroup.kill
Date: Mon, 10 May 2021 09:39:02 -0600
Message-ID: <874kfaha3t.fsf@meer.lwn.net>
References: <20210508121542.1269256-1-brauner@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 558132B4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
        t=1620661143; bh=kAxTOos9FhekUtxqCg7hz6hwN4pulQIZ55PVCksaoi0=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=PTniAJrYlNDmkQ6f+1nDRzUQlwTUPhkx+L6/kP43U0/cGCzORYOmTAaQq3+UTpeqE
         D4uyD634BSuIgKb0ucUpW3hsX7XH4OL55XS2xzLD12p4UtA757JIhGNhm3/SMUytL8
         LiftNqplFiKPRxOaxcD8q1RJJtHZc8eOGBiRJyHmp/sULa5RTjpncocQgv9tJJxNy9
         23+b8XRuu0MabjyZzB8Zpsk61S7mw0Cjpksgy3yHScFfaFkz+3fD/eqbzGmsqXQQbE
         6WWAw9KTbxn+ljHG0MI6l7xKO5QB0rhM6rauBi8rf0+ss4P7tY7nGWfpCIXs85gF6H
         HJUE96da1+Mig==
In-Reply-To: <20210508121542.1269256-1-brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>

Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> writes:

> Introduce the cgroup.kill file. It does what it says on the tin and
> allows a caller to kill a cgroup by writing "1" into cgroup.kill.
> The file is available in non-root cgroups.

So I feel like I'm missing something fundamental here...perhaps somebody
can supply a suitable cluebat.  It seems inevitable to me that, sooner
or later, somebody will surely wish that this mechanism could send a
signal other than SIGKILL, but this interface won't allow that.  Even if
you won't want to implement an arbitrary signal now, it seems like
defining the interface to require writing "9" rather than "1" would
avoid closing that option off in the future.

I assume there's some reason why you don't want to do that, but I'm to
slow to figure out what it is...?

Thanks,

jon
