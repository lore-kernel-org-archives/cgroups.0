From: Roman Gushchin <guro@fb.com>
Subject: Re: [RFC PATCH 0/2] mm/memcontrol: Finer-grained memory control
Date: Thu, 11 Apr 2019 21:21:35 +0000
Message-ID: <20190411212129.GA31565@tower.DHCP.thefacebook.com>
References: <20190410191321.9527-1-longman@redhat.com>
 <20190410213824.GA13638@chrisdown.name>
 <d8d6f82f-a950-8eea-16ce-9189e78f37fd@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=J59ZmlOdTWha1uc+6rXK0NSv6K3t61Wr5VdtTAYniFg=;
 b=C5Q/ZxjmL8Qsp02unNiG36lJkdXCpOGra3lM0wBog4IyNkgvVpJlkIcrBik23nPrtaqN
 hh7WIW9JLH1s8suulT/5EPEEwP5fStblJIW9vgKhZuCXf0ayyK7DDecySE5RLF5RVmIC
 r1mBWGls6Cm891o8o5+fKmxhfd9XkqYDGmg= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J59ZmlOdTWha1uc+6rXK0NSv6K3t61Wr5VdtTAYniFg=;
 b=GaprauWMbNYde7rr4mieyFI2H44/tHhhsUtQhFZm8f9kwTkWDYqYr5LwsWoCA9rYmienACKXhi+A4DlGIXCMli81eA0joVUq3KYD2gwWt1LYz0hA+zwC2ijyAS5A9dOMLqswmUzWqYDceQyxtcfIQHYg4OWgwroJ23egA/6DJeY=
In-Reply-To: <d8d6f82f-a950-8eea-16ce-9189e78f37fd@redhat.com>
Content-Language: en-US
Content-ID: <1E5B2719146AB44CB3FB15816522B144@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Waiman Long <longman@redhat.com>
Cc: Chris Down <chris@chrisdown.name>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, Shakeel Butt <shakeelb@google.com>, Kirill Tkhai <ktkhai@virtuozzo.com>

On Thu, Apr 11, 2019 at 10:22:22AM -0400, Waiman Long wrote:
> On 04/10/2019 05:38 PM, Chris Down wrote:
> > Hi Waiman,
> >
> > Waiman Long writes:
> >> The current control mechanism for memory cgroup v2 lumps all the memor=
y
> >> together irrespective of the type of memory objects. However, there
> >> are cases where users may have more concern about one type of memory
> >> usage than the others.
> >
> > I have concerns about this implementation, and the overall idea in
> > general. We had per-class memory limiting in the cgroup v1 API, and it
> > ended up really poorly, and resulted in a situation where it's really
> > hard to compose a usable system out of it any more.
> >
> > A major part of the restructure in cgroup v2 has been to simplify
> > things so that it's more easy to understand for service owners and
> > sysadmins. This was intentional, because otherwise the system overall
> > is hard to make into something that does what users *really* want, and
> > users end up with a lot of confusion, misconfiguration, and generally
> > an inability to produce a coherent system, because we've made things
> > too hard to piece together.
> >
> > In general, for purposes of resource control, I'm not convinced that
> > it makes sense to limit only one kind of memory based on prior
> > experience with v1. Can you give a production use case where this
> > would be a clear benefit, traded off against the increase in
> > complexity to the API?
> >
>=20
> As I said in my previous email on this thread, the customer considered
> pages cache as common goods not fully representing the "real" memory
> footprint used by an application.=A0 Depending on actual mix of
> applications running on a system, there are certainly cases where their
> view is correct. In fact, what the customer is asking for is not even
> provided by the v1 API even with that many classes of memory that you
> can choose from.

Hello Waiman!

If I understand the case correctly, the customer wants to get signaled
when anon memory consumption will reach a certain point, right?

I doubt that the idea is to keep only the certain amount of anon memory
resident and swap out everything else. So, probably, the reaction will
be to kill the application.

If so, do we really need a control?
Maybe polling memory.stats::anon will be enough?

If not, I can imagine some sort of threshold notification mechanism
on top of memory.stats. Similar to what is build on top of psi.

Tracking the size of anon memory is definitely useful for spotting
userspace leaks and spkies, so an ability to set up thresholds and get
events sounds appealing to me.

Thanks!

Roman
