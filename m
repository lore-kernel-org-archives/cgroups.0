From: Jerome Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/5] mm/memcontrol: allow to uncharge page without using
 page->lru field
Date: Mon, 10 Jul 2017 12:25:42 -0400
Message-ID: <20170710162542.GB4964@redhat.com>
References: <20170703211415.11283-1-jglisse@redhat.com>
 <20170703211415.11283-5-jglisse@redhat.com>
 <20170704125113.GC14727@dhcp22.suse.cz>
 <20170705143528.GB3305@redhat.com>
 <20170710082805.GD19185@dhcp22.suse.cz>
 <20170710153222.GA4964@redhat.com>
 <20170710160444.GB7071@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.redhat.com 39F5E3B738
Content-Disposition: inline
In-Reply-To: <20170710160444.GB7071-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, John Hubbard <jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, David Nellans <dnellans-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Jul 10, 2017 at 06:04:46PM +0200, Michal Hocko wrote:
> On Mon 10-07-17 11:32:23, Jerome Glisse wrote:
> > On Mon, Jul 10, 2017 at 10:28:06AM +0200, Michal Hocko wrote:
> > > On Wed 05-07-17 10:35:29, Jerome Glisse wrote:
> > > > On Tue, Jul 04, 2017 at 02:51:13PM +0200, Michal Hocko wrote:
> > > > > On Mon 03-07-17 17:14:14, J=E9r=F4me Glisse wrote:
> > > > > > HMM pages (private or public device pages) are ZONE_DEVICE page=
 and
> > > > > > thus you can not use page->lru fields of those pages. This patch
> > > > > > re-arrange the uncharge to allow single page to be uncharge wit=
hout
> > > > > > modifying the lru field of the struct page.
> > > > > >=20
> > > > > > There is no change to memcontrol logic, it is the same as it was
> > > > > > before this patch.
> > > > >=20
> > > > > What is the memcg semantic of the memory? Why is it even charged?=
 AFAIR
> > > > > this is not a reclaimable memory. If yes how are we going to deal=
 with
> > > > > memory limits? What should happen if go OOM? Does killing an proc=
ess
> > > > > actually help to release that memory? Isn't it pinned by a device?
> > > > >=20
> > > > > For the patch itself. It is quite ugly but I haven't spotted anyt=
hing
> > > > > obviously wrong with it. It is the memcg semantic with this class=
 of
> > > > > memory which makes me worried.
> > > >=20
> > > > So i am facing 3 choices. First one not account device memory at al=
l.
> > > > Second one is account device memory like any other memory inside a
> > > > process. Third one is account device memory as something entirely n=
ew.
> > > >=20
> > > > I pick the second one for two reasons. First because when migrating
> > > > back from device memory it means that migration can not fail because
> > > > of memory cgroup limit, this simplify an already complex migration
> > > > code. Second because i assume that device memory usage is a transie=
nt
> > > > state ie once device is done with its computation the most likely
> > > > outcome is memory is migrated back. From this assumption it means
> > > > that you do not want to allow a process to overuse regular memory
> > > > while it is using un-accounted device memory. It sounds safer to
> > > > account device memory and to keep the process within its memcg
> > > > boundary.
> > > >=20
> > > > Admittedly here i am making an assumption and i can be wrong. Thing
> > > > is we do not have enough real data of how this will be use and how
> > > > much of an impact device memory will have. That is why for now i
> > > > would rather restrict myself to either not account it or account it
> > > > as usual.
> > > >=20
> > > > If you prefer not accounting it until we have more experience on how
> > > > it is use and how it impacts memory resource management i am fine w=
ith
> > > > that too. It will make the migration code slightly more complex.
> > >=20
> > > I can see why you want to do this but the semantic _has_ to be clear.
> > > And as such make sure that the exiting task will simply unpin and
> > > invalidate all the device memory (assuming this memory is not shared
> > > which I am not sure is even possible).
> >=20
> > So there is 2 differents path out of device memory:
> >   - munmap/process exiting: memory will get uncharge from its memory
> >     cgroup just like regular memory
>=20
> I might have missed that in your patch, I admit I only glanced through
> that, but the memcg uncharged when the last reference to the page is
> released. So if the device pins the page for some reason then the charge
> will be there even when the oom victim unmaps the memory.

Device can not pin memory it is part of the "contract" when using HMM.
Device memory can never be pin. Nor by device driver nor by any other
means ie we want GUP to trigger a migration back to regular memory. We
will relax the GUP requirement a one point (especialy for direct I/O
and other short time GUP).


> >   - migration to non device memory, the memory cgroup charge get
> >     transfer to the new page just like for any other page
> >=20
> > Do you want me to document all this in any specific place ? I will
> > add a comment in memory_control.c and in HMM documentations for this
> > but should i add it anywhere else ?
>=20
> hmm documentation is sufficient and the uncharge path if it needs any
> special handling.

Uncharge happens in the ZONE_DEVICE special handling of page refcount
ie a ZONE_DEVICE is free when its refcount reach 1 not 0.

>=20
> > Note that the device memory is not pin. The whole point of HMM is to
> > do away with any pining. Thought as device page are not on lru they
> > are not reclaim like any other page. However we expect that device
> > driver might implement something akin to device memory reclaim to
> > make room for more important data base on statistic collected by the
> > device driver. If there is enough commonality accross devices then
> > we might implement a more generic mechanisms but at this point i
> > rather grow as we learn.
>=20
> Do we have any guarantee that devices will _never_ pin those pages? If
> no then we have to make sure we can forcefully tear them down.

Well yes we do, as long as i monitor how driver use thing :) Device we
are targetting are like CPU from MMU point of view ie you can tear down
a device page table entry without having the device to freak about it.
So there is no need for device to pin anything, if we update its page
table to non present entry any further access to the virtual address
will trigger a fault that is then handled by the device driver.

If the process is being kill than the GPU threads can be kill by the
device driver too. Otherwise the page fault is handled with the help
of HMM like any reguler CPU page fault. If for some reasons we can not
service the fault than the device driver is responsible to decide how
to handle various VM_FAULT_ERROR. Expectation is that it kills the
device threads and inform userspace through device specific API. I
think at one point down the road we will want to standardize way to
communicate fatal error condition that affect device threads.


I will review HMM documentation again to make sure this is all in
black and white. I am pretty sure that some of it is already there.

Bottom line is that we can always free and uncharge device memory
page just like any regular page.

Cheers,
J=E9r=F4me
