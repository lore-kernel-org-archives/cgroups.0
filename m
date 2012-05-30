From: Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH v3 3/6] expose fine-grained per-cpu data for cpuacct stats
Date: Wed, 30 May 2012 16:52:31 +0400
Message-ID: <4FC6180F.9020009@parallels.com>
References: <1338371317-5980-1-git-send-email-glommer@parallels.com> <1338371317-5980-4-git-send-email-glommer@parallels.com> <CAPM31RJanAvDB+pZ+h5J3W6KXvAwPgbbeXgw6C_56tx_Mc+cgA@mail.gmail.com> <4FC6107F.9020802@parallels.com> <CAPM31RJ7s+pNciOEnsfXRU9xCwnUano1k8CTEUuCjsSN5n0-1Q@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAPM31RJ7s+pNciOEnsfXRU9xCwnUano1k8CTEUuCjsSN5n0-1Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, devel@openvz.org, Peter Zijlstra <a.p.zijlstra@chello.nl>, Tejun Heo <tj@kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, handai.szj@gmail.com, Andrew.Phillips@lmax.com, Serge Hallyn <serge.hallyn@canonical.com>

On 05/30/2012 04:48 PM, Paul Turner wrote:
> a) the information in /proc/stat is actually much denser since it's
> "cpu VAL VAL VAL VAL" as opposed to "cpuX.FIELD VAL"

easily fixable here. Less descriptive, but we can use a header line
with the description much like how /proc/slabinfo does, and we still
have an extensible interface that is dense, at the same time.

> b) If it became a problem the /proc/stat case is actually fairly
> trivially fixable by defining each cpu as a record and "everything
> else" as a magic im-out-of-cpus value.
>
>> >
>> >  Now, if you guys are okay with a file per-cpu, I can do it as well.
>> >  It pollutes the filesystem, but at least protects against the fact that this
>> >  is kmalloc-backed.
>> >
> As I prefaced, I'm not sure there's much that can be trivially done
> about it.  This is really a fundamental limitation of how read_map()
> works.
>
> What we really need is a proper seq_file exposed through cftypes.
That can be done.
