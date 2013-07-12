From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH cgroup/for-3.12] cgroup: replace
 task_cgroup_path_from_hierarchy() with task_cgroup_path()
Date: Fri, 12 Jul 2013 13:02:47 -0700
Message-ID: <20130712200247.GG23680@mtj.dyndns.org>
References: <20130711233448.GA2359@htj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=xBqHiWY+T+0RmSSQh2JK1jG1rNWojFph0MQsQ+BQRQg=;
        b=QPt5TYtghx0gArh+faHxAhs0K70WkNKqmoNk+XF6s9+1woldzRhnuxzL4KbmfV14zM
         3ZDg6BqjbTuVZgJe21w/7HfFzy7bdE6G5gmN8YKMfYLF4amLg54bCl3Hk5jtnQbrCnJL
         2UYVHmUZAs4+U14YuzV/8HLU8+oYYNSAr+7Tl2eCo3Qnlof/0IQlGeBSKK6voPhvgyFA
         x31RYAJea1VLF525dpfW5HPv5NKY0AjBPqyCCU4FeAhyaQwr2Cfs5HXm3kBIx+iPMJjZ
         dY2Gj2ngNdMLpbBLKX/Wl0F4nQyaPzRF+Xk41x2YOyCdkBbj5uHaBTi9ZbDhBAmzjrO+
         8r6Q==
Content-Disposition: inline
In-Reply-To: <20130711233448.GA2359-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Jan =?utf-8?Q?Kalu=C5=BEa?= <jkaluza-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Thu, Jul 11, 2013 at 04:34:48PM -0700, Tejun Heo wrote:
> task_cgroup_path_from_hierarchy() was added for the planned new users
> and none of the currently planned users wants to know about multiple
> hierarchies.  This patch drops the multiple hierarchy part and makes
> it always return the path in the first non-dummy hierarchy.
>=20
> As unified hierarchy will always have id 1, this is guaranteed to
> return the path for the unified hierarchy if mounted; otherwise, it
> will return the path from the hierarchy which happens to occupy the
> lowest hierarchy id, which will usually be the first hierarchy mounte=
d
> after boot.
>=20
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>
> Cc: Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>
> Cc: Jan Kalu=C5=BEa <jkaluza-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Applied this to cgroup/for-3.11-fixes so that the out-of-tree usages
currently being developed can target 3.11 kernel.  This function
currently doesn't have any in-tree users so this won't affect
anything.

Thanks.

--=20
tejun
