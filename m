From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 4/5] mm/memcontrol: allow to uncharge page without using
 page->lru field
Date: Mon, 10 Jul 2017 18:04:46 +0200
Message-ID: <20170710160444.GB7071@dhcp22.suse.cz>
References: <20170703211415.11283-1-jglisse@redhat.com>
 <20170703211415.11283-5-jglisse@redhat.com>
 <20170704125113.GC14727@dhcp22.suse.cz>
 <20170705143528.GB3305@redhat.com>
 <20170710082805.GD19185@dhcp22.suse.cz>
 <20170710153222.GA4964@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20170710153222.GA4964@redhat.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Jerome Glisse <jglisse@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, John Hubbard <jhubbard@nvidia.com>, David Nellans <dnellans@nvidia.com>, Dan Williams <dan.j.williams@intel.com>, Balbir Singh <bsingharora@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org

On Mon 10-07-17 11:32:23, Jerome Glisse wrote:
> On Mon, Jul 10, 2017 at 10:28:06AM +0200, Michal Hocko wrote:
> > On Wed 05-07-17 10:35:29, Jerome Glisse wrote:
> > > On Tue, Jul 04, 2017 at 02:51:13PM +0200, Michal Hocko wrote:
> > > > On Mon 03-07-17 17:14:14, J=E9r=F4me Glisse wrote:
> > > > > HMM pages (private or public device pages) are ZONE_DEVICE page a=
nd
> > > > > thus you can not use page->lru fields of those pages. This patch
> > > > > re-arrange the uncharge to allow single page to be uncharge witho=
ut
> > > > > modifying the lru field of the struct page.
> > > > >=20
> > > > > There is no change to memcontrol logic, it is the same as it was
> > > > > before this patch.
> > > >=20
> > > > What is the memcg semantic of the memory? Why is it even charged? A=
FAIR
> > > > this is not a reclaimable memory. If yes how are we going to deal w=
ith
> > > > memory limits? What should happen if go OOM? Does killing an process
> > > > actually help to release that memory? Isn't it pinned by a device?
> > > >=20
> > > > For the patch itself. It is quite ugly but I haven't spotted anythi=
ng
> > > > obviously wrong with it. It is the memcg semantic with this class of
> > > > memory which makes me worried.
> > >=20
> > > So i am facing 3 choices. First one not account device memory at all.
> > > Second one is account device memory like any other memory inside a
> > > process. Third one is account device memory as something entirely new.
> > >=20
> > > I pick the second one for two reasons. First because when migrating
> > > back from device memory it means that migration can not fail because
> > > of memory cgroup limit, this simplify an already complex migration
> > > code. Second because i assume that device memory usage is a transient
> > > state ie once device is done with its computation the most likely
> > > outcome is memory is migrated back. From this assumption it means
> > > that you do not want to allow a process to overuse regular memory
> > > while it is using un-accounted device memory. It sounds safer to
> > > account device memory and to keep the process within its memcg
> > > boundary.
> > >=20
> > > Admittedly here i am making an assumption and i can be wrong. Thing
> > > is we do not have enough real data of how this will be use and how
> > > much of an impact device memory will have. That is why for now i
> > > would rather restrict myself to either not account it or account it
> > > as usual.
> > >=20
> > > If you prefer not accounting it until we have more experience on how
> > > it is use and how it impacts memory resource management i am fine with
> > > that too. It will make the migration code slightly more complex.
> >=20
> > I can see why you want to do this but the semantic _has_ to be clear.
> > And as such make sure that the exiting task will simply unpin and
> > invalidate all the device memory (assuming this memory is not shared
> > which I am not sure is even possible).
>=20
> So there is 2 differents path out of device memory:
>   - munmap/process exiting: memory will get uncharge from its memory
>     cgroup just like regular memory

I might have missed that in your patch, I admit I only glanced through
that, but the memcg uncharged when the last reference to the page is
released. So if the device pins the page for some reason then the charge
will be there even when the oom victim unmaps the memory.

>   - migration to non device memory, the memory cgroup charge get
>     transfer to the new page just like for any other page
>=20
> Do you want me to document all this in any specific place ? I will
> add a comment in memory_control.c and in HMM documentations for this
> but should i add it anywhere else ?

hmm documentation is sufficient and the uncharge path if it needs any
special handling.

> Note that the device memory is not pin. The whole point of HMM is to
> do away with any pining. Thought as device page are not on lru they
> are not reclaim like any other page. However we expect that device
> driver might implement something akin to device memory reclaim to
> make room for more important data base on statistic collected by the
> device driver. If there is enough commonality accross devices then
> we might implement a more generic mechanisms but at this point i
> rather grow as we learn.

Do we have any guarantee that devices will _never_ pin those pages? If
no then we have to make sure we can forcefully tear them down.

--=20
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
