From: Petr =?UTF-8?B?VGVzYcWZw61r?= <petr@tesarici.cz>
Subject: Re: [PATCH 00/40] Memory allocation profiling
Date: Wed, 3 May 2023 12:26:27 +0200
Message-ID: <20230503122627.594ac4d9@meshulam.tesarici.cz>
References: <20230501165450.15352-1-surenb@google.com>
        <ZFIMaflxeHS3uR/A@dhcp22.suse.cz>
        <ZFIOfb6/jHwLqg6M@moria.home.lan>
        <ZFISlX+mSx4QJDK6@dhcp22.suse.cz>
        <20230503115051.30b8a97f@meshulam.tesarici.cz>
        <ZFIv+30UH7+ySCZr@moria.home.lan>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tesarici.cz; s=mail;
        t=1683109589; bh=9W2wun4Zj44NWzwdlLkMFEunLnmomS6UpnHu7fqlUvw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RY1nRufpXdiSJQ6rfVk/v4uXA2nZbsCbrGxRIhqVdNwr8SIfDdtDY4wpCe25wFasl
         w1BqEtqFdb98ncldz5L5BfdQOK+IXjg4m5WZXUipUraWgQ4LLS5Gz4bTdhA7osONxZ
         brJ4ucZmtLQyFnfvdAZ/2DlN8eiuApZyh0ThEGxdVpqahbsNeXkBtQm8i8/xxb5K96
         Lr9b6WGCJuYJeJTYx3TLMB66ZuisUQiGZ+/TINACO6wao1Sy5Fcc7O7Q9nQonYabtj
         9YchQQBbTEKrFokXu+MNG5CEj9cmbPrhJUEj7whSRU/w3oH5u/ir9+J7QPH/q3iyEo
         YhK1QSLkJNUkg==
In-Reply-To: <ZFIv+30UH7+ySCZr@moria.home.lan>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org, vbabka@suse.cz, hannes@cmpxchg.org, roman.gushchin@linux.dev, mgorman@suse.de, dave@stgolabs.net, willy@infradead.org, liam.howlett@oracle.com, corbet@lwn.net, void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org, peterx@redhat.com, david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org, dennis@kernel.org, tj@kernel.org, muchun.song@linux.dev, rppt@kernel.org, paulmck@kernel.org, pasha.tatashin@soleen.com, yosryahmed@google.com, yuzhao@google.com, dhowells@redhat.com

On Wed, 3 May 2023 05:57:15 -0400
Kent Overstreet <kent.overstreet@linux.dev> wrote:

> On Wed, May 03, 2023 at 11:50:51AM +0200, Petr Tesa=C5=99=C3=ADk wrote:
> > If anyone ever wants to use this code tagging framework for something
> > else, they will also have to convert relevant functions to macros,
> > slowly changing the kernel to a minefield where local identifiers,
> > struct, union and enum tags, field names and labels must avoid name
> > conflict with a tagged function. For now, I have to remember that
> > alloc_pages is forbidden, but the list may grow. =20
>=20
> Also, since you're not actually a kernel contributor yet...

I see, I've been around only since 2007...

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?=
id=3D2a97468024fb5b6eccee2a67a7796485c829343a

Petr T
