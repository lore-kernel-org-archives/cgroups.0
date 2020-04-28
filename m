From: Qian Cai <cai@lca.pw>
Subject: Re: [PATCH v2 4/4] mm/slub: Fix sysfs shrink circular locking dependency
Date: Mon, 27 Apr 2020 22:11:13 -0400
Message-ID: <28BB8A1C-CFDF-4F5A-8686-537C3CE04818@lca.pw>
References: <dbbfe685-7374-9a96-b7c2-684142746e30@redhat.com>
Mime-Version: 1.0 (1.0)
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=7634cSYNnkEeZLF9qaQ+2AgpibDUSOrBUl4aX1MYmtc=;
        b=ZRkzebefYI8C8YM+yiMqJuIxbcoHVPnVIoxvoL8/hgvaR74uXvHOvFl4346qeUIuUr
         7GZbXnz+22W3LePUoSJ2gWqSXyMqfX1aUWsfxdOmpYbgkh8OzGZ3kG4YzmdclLPek/RO
         oVJAxqoWqeclY26sXJcQs4W2JfjNzlx4Ey0FoMnFAYL9UxTnrZyoZzIjUm4gp+ozkZZB
         vFMTJiTsxGPCrFmtoqo4y0cxos0KVXLX5nMiiWNh/Qy+CCpNKygxhfkIy3hgeOu7PyAq
         oi2Y0OKlopHWpUuBSkiL0Ed0d0RcX12M4Hl2WS0lsStn0GM0VeqsPhoQqU3g67mlydnw
         wclw==
In-Reply-To: <dbbfe685-7374-9a96-b7c2-684142746e30@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Waiman Long <longman@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>



> On Apr 27, 2020, at 9:39 PM, Waiman Long <longman@redhat.com> wrote:
>=20
> The sequence that was prevented by this patch is "kn->count --> mem_hotplu=
g_lock.rwsem". This sequence isn't directly in the splat. Once this link is b=
roken, the 3-lock circular loop cannot be formed. Maybe I should modify the c=
ommit log to make this point more clear.

I don=E2=80=99t know what you are talking about. Once trylock succeed once, y=
ou will have kn->count =E2=80=94> cpu/memory_hotplug_lock.=
