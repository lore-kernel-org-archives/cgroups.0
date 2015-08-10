From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cpuset: use trialcs->mems_allowed as a temp variable
Date: Mon, 10 Aug 2015 11:19:46 -0400
Message-ID: <20150810151946.GA23408@mtj.duckdns.org>
References: <1438870865-25468-1-git-send-email-alban@endocode.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=DdPRlIINZbzwuYzhnOLYMhrvyQdl08U6oc0OiXy85Fw=;
        b=eTpAd338gXHQx1dYX8ETgfBggLtusQDAokGP/YMJGPyFG8OP3h8bLIDdMcc8nv3pKD
         Jeg2KQzmaDEHnZP9/V6xeBJMrvdAkcII2Q8dbi1FbHGAq5UI5HXHqS2mFghRZeBSk7/t
         n9DjSJ2FqTNoodkeYffj/ooUP22pZGbC+AxHZCZFYi73UsK9ncmzljIm9TEjphX89lu3
         53Zq541Acy6qFZk/7buhrHkxBGTBH81MRroxS4xDjsszbOklBrffMB9z0SzHljwIRNCb
         5hni9ICUoHeRPsZmzx5l1KzP+k9fw1G95u9kinfPXwzlOru6uoMmvGU5vK1nlKlQjcmJ
         T+tg==
Content-Disposition: inline
In-Reply-To: <1438870865-25468-1-git-send-email-alban-973cpzSjLbNWk0Htik3J/w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Alban Crequy <alban.crequy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Alban Crequy <alban-973cpzSjLbNWk0Htik3J/w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Iago Lopez Galeiras <iago-973cpzSjLbNWk0Htik3J/w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

On Thu, Aug 06, 2015 at 04:21:05PM +0200, Alban Crequy wrote:
> The comment says it's using trialcs->mems_allowed as a temp variable =
but
> it didn't match the code. Change the code to match the comment.
>=20
> This fixes an issue when writing in cpuset.mems when a sub-directory
> exists: we need to write several times for the information to persist=
:
>=20
> | root@alban:/sys/fs/cgroup/cpuset# mkdir footest9
> | root@alban:/sys/fs/cgroup/cpuset# cd footest9
> | root@alban:/sys/fs/cgroup/cpuset/footest9# mkdir aa
> | root@alban:/sys/fs/cgroup/cpuset/footest9# cat cpuset.mems
> |
> | root@alban:/sys/fs/cgroup/cpuset/footest9# echo 0 > cpuset.mems
> | root@alban:/sys/fs/cgroup/cpuset/footest9# cat cpuset.mems
> |
> | root@alban:/sys/fs/cgroup/cpuset/footest9# echo 0 > cpuset.mems
> | root@alban:/sys/fs/cgroup/cpuset/footest9# cat cpuset.mems
> | 0
> | root@alban:/sys/fs/cgroup/cpuset/footest9# cat aa/cpuset.mems
> |
> | root@alban:/sys/fs/cgroup/cpuset/footest9# echo 0 > aa/cpuset.mems
> | root@alban:/sys/fs/cgroup/cpuset/footest9# cat aa/cpuset.mems
> | 0
> | root@alban:/sys/fs/cgroup/cpuset/footest9#
>=20
> This should help to fix the following issue in Docker:
> https://github.com/opencontainers/runc/issues/133
> In some conditions, a Docker container needs to be started twice in
> order to work.
>=20
> Signed-off-by: Alban Crequy <alban-973cpzSjLbNWk0Htik3J/w@public.gmane.org>
> Tested-by: Iago L=F3pez Galeiras <iago-973cpzSjLbNWk0Htik3J/w@public.gmane.org>

Applied to cgroup/for-4.2-fixes w/ stable cc'd.

Thanks.

--=20
tejun
