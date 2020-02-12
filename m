From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 3/3] kselftest/cgroup: add cgroup destruction test
Date: Wed, 12 Feb 2020 17:10:03 -0500
Message-ID: <20200212221003.GI80993@mtj.thefacebook.com>
References: <20200120145635.GA30904@blackbody.suse.cz>
 <20200124114017.8363-1-mkoutny@suse.com>
 <20200124114017.8363-4-mkoutny@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=cdFC4Sw+amJDnEOMffYysz3PsfK9sMY043rnSWe7/YM=;
        b=KAdSUhYCm4EKSCvAwuyjpY9CBE8LkbBg+RlKisgUNO2Gp0VpVBxINmGcQqUFUjWf2T
         e20M3V0f5wA5yiqnJi2kJ/EXBV0Dl6xWgNdwpVyvjdZegwbvseDkjvsZNALFZQOvhliN
         VllY7hDUn5+cDbxx2pKS+H2AG2RUHhMwPD6C1kZ8/pCoXNg93+BnJVRJKWjjhelynDeJ
         BoWhGrPYv0YnZRVCDvCWSJhQsvb757R7wMhajhvhImQpghd1/01Us6N6oEs4IfNxXmsA
         aQLsb5baITGLE4uDuw0JxWjWNyslVzFaWD2ym7uGdtGBheqZVFgDfphydU//+bVS/pn8
         WsLA==
Content-Disposition: inline
In-Reply-To: <20200124114017.8363-4-mkoutny-IBi9RG/b67k@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, linger.lee-NuS5LvNUpcJWk0Htik3J/w@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mediatek-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, matthias.bgg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tomcherry-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

On Fri, Jan 24, 2020 at 12:40:17PM +0100, Michal Koutn=FD wrote:
> From: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>=20
> Add new test to verify that a cgroup with dead processes can be destroyed.
> The test spawns a child process which allocates and touches 100MB of RAM
> to ensure prolonged exit. Subsequently it kills the child, waits until
> the cgroup containing the child is empty and destroys the cgroup.
>=20
> Signed-off-by: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.g=
mane.org>
> [mkoutny-IBi9RG/b67k@public.gmane.org: Fix typo in test_cgcore_destroy co=
mment]
> Acked-by: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>
> Signed-off-by: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>

Applied 2-3 to cgroup/for-5.7.

Thanks a lot for working on this!

--=20
tejun
