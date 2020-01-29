From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Subject: Re: [PATCH] cgroup.c: Use built-in RCU list checking
Date: Wed, 29 Jan 2020 21:37:52 +0530
Message-ID: <20200129160752.GA15913@madhuparna-HP-Notebook>
References: <20200118031051.28776-1-madhuparnabhowmik10@gmail.com>
 <20200129142255.GE11384@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=8JqRhiDOHvgPoZeVnB2/bI1P2RUwGdHALzeY09zc6AU=;
        b=ub6sLpwwTWJc0DJT5UDWjzIwiugnQZno6L7yV/YzPZ8PqzySLQXrh33ibMBqECPhJD
         i9qOjKCFkLgTXci2siKMJV8UPCXQp64Lyq1A1WUISGnU8/VjWj/5CSaxVIoRiykTHk1p
         JPKxjK2SB0vZgMmpC4PEnEqnqzkH1P0ggO2vuTFS+ycnVNAXDMjdpH2IcFE9er0hsq2n
         1f/zNiMjsiyUqIDoHgijiNx8MFfRWO6nS6mwZ7mfh/xk0B22tJ4KUfJ8+19iGNKxOV68
         NFdruNQIX4Qj4BMlPk4Rwuf/xEYyeCne9qEkSUEnt8UGY1tYI1t/6sQAeJKSE8jU0w4Y
         j04w==
Content-Disposition: inline
In-Reply-To: <20200129142255.GE11384@blackbody.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: madhuparnabhowmik10@gmail.com, tj@kernel.org, lizefan@huawei.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, joel@joelfernandes.org, rcu@vger.kernel.org, frextrite@gmail.com

On Wed, Jan 29, 2020 at 03:22:55PM +0100, Michal Koutn=FD wrote:
> Hello.
>=20
> On Sat, Jan 18, 2020 at 08:40:51AM +0530, madhuparnabhowmik10@gmail.com w=
rote:
> > From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
> >=20
> > list_for_each_entry_rcu has built-in RCU and lock checking.
> > Pass cond argument to list_for_each_entry_rcu() to silence
> > false lockdep warning when  CONFIG_PROVE_RCU_LIST is enabled
> > by default.
> I assume if you've seen the RCU warning, you haven't seen the warning
> from cgroup_assert_mutex_or_rcu_locked() above.=20
>
No, I haven't seen any warning from cgroup_assert_mutex_or_rcu_locked(),
I am just doing the conversions to prevent any false lockdep warnings
because of CONFIG_PROVE_RCU_LIST in the future.

> The patch makes sense to me from the consistency POV.
>=20
Thank you,
Madhuparna

> Acked-by: Michal Koutn=FD <mkoutny@suse.com>
>=20
> Michal
