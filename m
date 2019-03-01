From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH] mm, memcg: Make scan aggression always exclude protection
Date: Fri, 1 Mar 2019 00:03:06 +0000
Message-ID: <20190301000300.GA16802@tower.DHCP.thefacebook.com>
References: <20190228213050.GA28211@chrisdown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=MCWn9st21+H4Wm1qn+nfXI52WnHcROTMb4DEd5uE1Ow=;
 b=Pd7l+hcvu2pm0F9fBCNVMkhl1hxam/Cs9QBsW8cKvJ3mZSWaVxwLEEsg3EnyiAR6hKHk
 3vNEGlZ8lJbiyREU66gVfKGCTBjOjkMxbIat6PQutflwzaioYbJiXaljfUYOezuSlyRL
 gu0lCpjRIC4shPIFzX8XzZFDYS6vPlzrqZA= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MCWn9st21+H4Wm1qn+nfXI52WnHcROTMb4DEd5uE1Ow=;
 b=kZ3gpSiLDm9x0L8/nEJpVIbWp9hyiXQDFOaEzLLX7ADEcn9+NSDlHA42+rd5PtizayxlFrVV62okNalc+oJ5kd+uV/jxorIs4aV05XHk4hESgKqpDiIW5BhRCa3wSgPGzumPZef8qdstcVjgCUzIgtupMqWH/2AD70KBed/b6QY=
In-Reply-To: <20190228213050.GA28211@chrisdown.name>
Content-Language: en-US
Content-ID: <E321688B1AD6AA47BB869EFB072F8E3F@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Kernel Team <Kernel-team@fb.com>

On Thu, Feb 28, 2019 at 09:30:50PM +0000, Chris Down wrote:
> This patch is an incremental improvement on the existing
> memory.{low,min} relative reclaim work to base its scan pressure
> calculations on how much protection is available compared to the current
> usage, rather than how much the current usage is over some protection
> threshold.
>=20
> Previously the way that memory.low protection works is that if you are
> 50% over a certain baseline, you get 50% of your normal scan pressure.
> This is certainly better than the previous cliff-edge behaviour, but it
> can be improved even further by always considering memory under the
> currently enforced protection threshold to be out of bounds. This means
> that we can set relatively low memory.low thresholds for variable or
> bursty workloads while still getting a reasonable level of protection,
> whereas with the previous version we may still trivially hit the 100%
> clamp. The previous 100% clamp is also somewhat arbitrary, whereas this
> one is more concretely based on the currently enforced protection
> threshold, which is likely easier to reason about.
>=20
> There is also a subtle issue with the way that proportional reclaim
> worked previously -- it promotes having no memory.low, since it makes
> pressure higher during low reclaim. This happens because we base our
> scan pressure modulation on how far memory.current is between memory.min
> and memory.low, but if memory.low is unset, we only use the overage
> method. In most cromulent configurations, this then means that we end up
> with *more* pressure than with no memory.low at all when we're in low
> reclaim, which is not really very usable or expected.
>=20
> With this patch, memory.low and memory.min affect reclaim pressure in a
> more understandable and composable way. For example, from a user
> standpoint, "protected" memory now remains untouchable from a reclaim
> aggression standpoint, and users can also have more confidence that
> bursty workloads will still receive some amount of guaranteed
> protection.

Looks good to me: the overall logic is fine, and codewise it's so much
cleaner than the previous version.

Reviewed-by: Roman Gushchin <guro@fb.com>

Thanks, Chris!
