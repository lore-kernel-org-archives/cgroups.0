From: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Subject: Re: [RFC v3 00/12] DRM scheduling cgroup controller
Date: Fri, 27 Jan 2023 11:40:58 +0000
Message-ID: <246fefac-6c1d-e4f1-c0df-721ca23ab56a@linux.intel.com>
References: <20230112165609.1083270-1-tvrtko.ursulin@linux.intel.com>
 <20230123154239.GA24348@blackbody.suse.cz>
 <371f3ce5-3468-b91d-d688-7e89499ff347@linux.intel.com>
 <20230126130050.GA22442@blackbody.suse.cz> <Y9KyiCPYj2Mzym3Z@slm.duckdns.org>
 <b8a0872c-fe86-b174-ca3b-0fc04a98e224@linux.intel.com>
 <20230127100428.GA3527@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
 d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
 t=1674819666; x=1706355666;
 h=message-id:date:mime-version:subject:to:cc:references:
 from:in-reply-to:content-transfer-encoding;
 bh=++zl8Fr1gHaHdEpfDVW0NPiIeaWIfdHRn3Gz0GJc96k=;
 b=Vmk99nUT8/rdmpaDpCN7JMbpNcPrRdvflx6r88VhmId4MULA2DawrwX9
 YrS9UjK1jK5/gLKhO3lZqtIOx5MZgXfPKeEckDnP84g02+QnEIYBuV5kQ
 RzoUEIGBOsILHGrt9rB8L3OMOeNhglJCBR7g4gZ24O9tx5Oxx7cK00mYd
 17RDqqJGPo9V0Sojeqsui/pUfc2yilPUr8D7iogeQDAIqsexu3FRZrNaE
 a6p1WsYdRu3DKTOzqWoJh2xyURKoyCOROpPut5vKHPeznbP2o+DiMuugu
 8A7zrLVIp1gK5oFHGFsWapPA2FLoFrkYvKGk9mN2LRqkbU3rAy6TInNte Q==;
Content-Language: en-US
In-Reply-To: <20230127100428.GA3527@blackbody.suse.cz>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/intel-gfx>
List-Post: <mailto:intel-gfx@lists.freedesktop.org>
List-Help: <mailto:intel-gfx-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=subscribe>
Errors-To: intel-gfx-bounces@lists.freedesktop.org
Sender: "Intel-gfx" <intel-gfx-bounces@lists.freedesktop.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>
Cc: Rob Clark <robdclark@chromium.org>, Kenny.Ho@amd.com, Dave Airlie <airlied@redhat.com>, =?UTF-8?Q?St=c3=a9phane_Marchesin?= <marcheu@chromium.org>, Daniel Vetter <daniel.vetter@ffwll.ch>, Intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, "T . J . Mercier" <tjmercier@google.com>


On 27/01/2023 10:04, Michal Koutn=C3=BD wrote:
> On Thu, Jan 26, 2023 at 05:57:24PM +0000, Tvrtko Ursulin <tvrtko.ursulin@=
linux.intel.com> wrote:
>> So even if the RFC shows just a simple i915 implementation, the controll=
er
>> itself shouldn't prevent a smarter approach (via exposed ABI).
>=20
> scan/query + over budget notification is IMO limited in guarantees.

It is yes, I tried to stress out that it is not a hard guarantee in any=20
shape and form and that the "quality" of adhering to the allocated=20
budget will depend on individual hw and sw capabilities.

But it is what I believe is the best approach given a) how different in=20
scheduling capability GPU drivers are and b) the very fact there isn't a=20
central scheduling entity as opposed to the CPU side of things.

It is just no possible to do a hard guarantee system. GPUs do not=20
preempt as nicely and easily as the CPUs do. And the frequency of=20
context switches varies widely from too fast to "never", so again,=20
charging would have several problems to overcome which would make the=20
whole setup IMHO pointless.

And not only that some GPUs do not preempt nicely, but some even can't=20
do any of this, period. Even if we stay within the lineage of hardware=20
supported by only i915, we have three distinct categories: 1) can't do=20
any of this, 2a) can do fine grained priority based scheduling with=20
reasonable preemption capability, 2b) ditto but without reasonable=20
preemption capability, and 3) like 2a) and 2b) but with the scheduler in=20
the firmware and currently supporting coarse priority based scheduling.

Shall I also mention that a single cgroup can contain multiple GPU=20
clients, all using different GPUs with a different mix of the above=20
listed challenges?

The main point is, should someone prove me wrong and come up a smarter=20
way at some point in the future, then "drm.weight" as an ABI remains=20
compatible and the improvement can happen completely under the hood. In=20
the mean time users get external control, and _some_ ability to improve=20
the user experience with the scenarios such as I described yesterday.

>> [...]
>> Yes agreed, and to re-stress out, the ABI as proposed does not preclude
>> changing from scanning to charging or whatever. The idea was for it to be
>> compatible in concept with the CPU controller and also avoid baking in t=
he
>> controlling method to individual drivers.
>> [...]
>=20
> But I submit to your point of rather not exposing this via cgroup API
> for possible future refinements.

Ack.

>> Secondly, doing this in userspace would require the ability to get some =
sort
>> of an atomic snapshot of the whole tree hierarchy to account for changes=
 in
>> layout of the tree and task migrations. Or some retry logic with some ad=
ded
>> ABI fields to enable it.
>=20
> Note, that the proposed implementation is succeptible to miscount due to
> concurrent tree modifications and task migrations too (scanning may not
> converge under frequent cgroup layout modifications, and migrating tasks
> may be summed 0 or >1 times). While in-kernel implementation may assure
> the snapshot view, it'd come at cost. (Read: since the mechanism isn't
> precise anyway, I don't suggest a fully synchronized scanning.)

The part that scanning may not converge in my _current implementation_=20
is true. For instance if clients would be constantly coming and going,=20
for that I took a shortcut of not bothering to accumulate usage on=20
process/client exit, and I just wait for a stable two periods to look at=20
the current state. I reckon this is possibly okay for the real world.

Cgroup tree hierarchy modifications being the reason for not converging=20
can also happen, but I thought I can hand wave that as not a realistic=20
scenario. Perhaps I am not imaginative enough?

Under or over-accounting for migrating tasks I don't think can happen=20
since I am explicitly handling that.

Regards,

Tvrtko
