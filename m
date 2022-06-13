From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v11 3/8] cgroup/cpuset: Allow no-task partition to have
 empty cpuset.cpus.effective
Date: Mon, 13 Jun 2022 07:23:03 -1000
Message-ID: <Yqdydz3vNgfVMgDf@slm.duckdns.org>
References: <20220510153413.400020-1-longman@redhat.com>
 <20220510153413.400020-4-longman@redhat.com>
 <YqYlCRywdgSYtwKk@slm.duckdns.org>
 <YqYlOQjKtQCBsQuT@slm.duckdns.org>
 <ce3106c1-a3c4-b449-bafc-6940d672bd94@redhat.com>
 <YqanEZZooeZwtutA@slm.duckdns.org>
 <20220613140206.GA6910@blackbody.suse.cz>
 <f1c33447-1f82-9698-6b0c-fc9ffb12b4bb@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=7M+A4Tkcl4j2ZEYJxnHofmbHWBP8K2O9jymdDhG9tv0=;
        b=SfbzRvanLsSXpQIXsHN2DLvLUMY5t8/g0db/VVEH7eeh+ei07KzvHZObXvbjTtVeim
         QqAtDY4GBjmFmerP5kZz+/mf7m/AS/3Q5XZMZOj/OJ8HDObBVWj2SDvQTRMUldRoZMZ+
         SeJLzy0p5MzASUh/0RwJPnMgBysfdsAoMl1zLmYslcAO+FOxbb8NVeSW1lz0Tf3iyUJ1
         7LDCIUE5aIDnihc8OtiMhEzJchy+X65LWl8FCJEPOHTTeMSAznyrJtD842u6apyMxgiI
         ZuePfGPvvzwdUYaLN3R4KH78h6kCwyviro32caqZmQSWGivj6/D750j/QfJwc+em2o6W
         8ANw==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <f1c33447-1f82-9698-6b0c-fc9ffb12b4bb@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Waiman Long <longman@redhat.com>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>

Hello,

On Mon, Jun 13, 2022 at 12:47:37PM -0400, Waiman Long wrote:
> On 6/13/22 10:02, Michal Koutn=FD wrote:
> > On Sun, Jun 12, 2022 at 04:55:13PM -1000, Tejun Heo <tj@kernel.org> wro=
te:
> > > But how would that happen? A lot of other things would break too if t=
hat
> > > were to happen.
> > cpuset is a threaded controller where the internal-node-constraint does
> > not hold. So the additional condition for cpuset migrations is IMO
> > warranted (and needed if there's no "fall up").
>=20
> Yes, you are right. cpuset is threaded and so it may have tasks even if it
> is not the leaf node.

And we had this same exchange the last time. Can you please add a comment?
We might also already have had this exchange before too but is it necessary
to allow threaded cgroups to be isolated roots? The interaction between
being threaded and isolated is cleaner at that layer as it's interactions
between two explicit mode changes.

Thanks.

--=20
tejun
