From: Qian Cai <cai@lca.pw>
Subject: Re: [PATCH] mm/memcontrol: fix a data race in scan count
Date: Sun, 9 Feb 2020 23:44:26 -0500
Message-ID: <6E237CA6-8968-4207-A9BB-1D18CB30822B@lca.pw>
References: <20200209202840.2bf97ffcfa811550d733c461@linux-foundation.org>
Mime-Version: 1.0 (1.0)
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=YyeG7ioMptg4bos9WvsiCAkWTH6MJSyQRYyd9Ee7o3E=;
        b=CPdOs3rbLRg9yoyCDZ5FfBtSmUGg5ALJ1rif3cwywsjGy6iXqxjHOs2/coCTOgCWM5
         skYy1c97oA7WOyENX5nrTq+i258mB5kN1lJ6844lZuBZ55mg3HCR3yJ2k3FqbD698WH9
         1ypDv2ONkoc6fKwj3eSu5D3ygeQmlfVUjzau9YjRVEkOQGPXAaizsj9SOgiQQBOFpL15
         GEiBmgJL5ZzsZP6WJoCEU8kAS/fwjWnPtNJjv3BBVhfnqza6eZKIcp/nCD2NX1Tnt2dp
         4FBNLfo7cGYWsbrfhI6Cbvxgs0IhF0Nt4PpEXKMRJcM6jnyLoPKKXvFbPUS1Glf1qWMw
         ZbYQ==
In-Reply-To: <20200209202840.2bf97ffcfa811550d733c461@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org



> On Feb 9, 2020, at 11:28 PM, Andrew Morton <akpm@linux-foundation.org> wro=
te:
>=20
> I worry about the readability/maintainability of these things.  A naive
> reader who comes upon this code will wonder "why the heck is it using
> READ_ONCE?".  A possibly lengthy trawl through the git history will
> reveal the reason but that's rather unkind.  Wouldn't a simple
>=20
>    /* modified under lru_lock, so use READ_ONCE */
>=20
> improve the situation?

Sure. I just don=E2=80=99t remember there are many places in the existing co=
de which put comments for READ_ONCE() and WRITE_ONCE(). For example, kernel/=
locking/osq_lock.c and kernel/rcu/srcutree.c, but I suppose every subsystem c=
ould be different.=
