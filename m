From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/3] cgroup: Unify css_set task lists
Date: Fri, 17 Jan 2020 08:59:18 -0800
Message-ID: <20200117165918.GJ2677547@devbig004.ftw2.facebook.com>
References: <20200116043612.52782-1-surenb@google.com>
 <20200117151533.12381-1-mkoutny@suse.com>
 <20200117151533.12381-2-mkoutny@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=zUnqRXYQtoyEF5UfPwWmYzCrDBoI5jZ6BUT1W4OJSHA=;
        b=dNwidGHTaO65iLrmuRFYsedrAORZcj1dlBJc6RMBU146ZCPVPbdo76G9xqEUHi/4Pt
         EOjOovq0mE5jq+flTugwLRNLMe/HfRwsgkV8518vOU7/DmxMI7XRE8vFRc/XRTgb/ICe
         rDke18QDeVAgygvYrcv/rpZui2Gx8OXVHY42jmMcwi2MkfLMXzY2zcHKratTxPYePE5C
         6/+6UJTgCLdF/6Q0CmUKGsNVRYhdpnM89yIl1USuXStY8jSq35oPPXc0UDZcFon7c8E7
         I38FBOrLF5KnNZx0uQLQ11UdW+T1YiVS3L6zDZSMoGQuQQo1a/NONcwN9ay/gtbQB1Jz
         70Xw==
Content-Disposition: inline
In-Reply-To: <20200117151533.12381-2-mkoutny@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: cgroups@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, Li Zefan <lizefan@huawei.com>, alex.shi@linux.alibaba.com, guro@fb.com, kernel-team@android.com, linger.lee@mediatek.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-mediatek@lists.infradead.org, matthias.bgg@gmail.com, shuah@kernel.org, tomcherry@google.com

On Fri, Jan 17, 2020 at 04:15:31PM +0100, Michal Koutn=FD wrote:
> We track tasks of css_set in three different lists. The iterators
> unnecessarily process each list specially.
> Use an array of lists and simplify the iterator code. This is
> refactoring with no intended functional change.
>=20
> Signed-off-by: Michal Koutn=FD <mkoutny@suse.com>
> ---
>  include/linux/cgroup-defs.h | 15 ++++---
>  include/linux/cgroup.h      |  4 +-
>  kernel/cgroup/cgroup.c      | 81 +++++++++++++++++++------------------
>  kernel/cgroup/debug.c       | 16 ++++----
>  4 files changed, 60 insertions(+), 56 deletions(-)

So, I get the urge to move the lists into an array and thought about
doing that while adding the third list for sure.  However, it does
make code paths which don't walk all lists wordier and the code path
is already tricky like hell.  Given that there aren't that many places
which loop over the lists, if you really wanna clean it up, maybe add
an interator over the lists so that both parts of code can look lean?

Thanks.

--=20
tejun
