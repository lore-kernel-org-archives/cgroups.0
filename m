From: Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [RFC PATCH 15/18] cgroup: Introduce ioasids controller
Date: Thu, 4 Mar 2021 09:46:03 -0800
Message-ID: <20210304094603.4ab6c1c4@jacob-builder>
References: <1614463286-97618-1-git-send-email-jacob.jun.pan@linux.intel.com>
 <1614463286-97618-16-git-send-email-jacob.jun.pan@linux.intel.com>
 <YD+u3CXhwOi2LC+4@slm.duckdns.org>
 <20210303131726.7a8cb169@jacob-builder>
 <20210303160205.151d114e@jacob-builder> <YECtMZNqSgh7jkGP@myrica>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <YECtMZNqSgh7jkGP@myrica>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
 <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
 <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Sender: "iommu" <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
To: Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Raj Ashok <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

Hi Jean-Philippe,

On Thu, 4 Mar 2021 10:49:37 +0100, Jean-Philippe Brucker
<jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:

> On Wed, Mar 03, 2021 at 04:02:05PM -0800, Jacob Pan wrote:
> > Hi Jacob,
> > 
> > On Wed, 3 Mar 2021 13:17:26 -0800, Jacob Pan
> > <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> >   
> > > Hi Tejun,
> > > 
> > > On Wed, 3 Mar 2021 10:44:28 -0500, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > >   
> > > > On Sat, Feb 27, 2021 at 02:01:23PM -0800, Jacob Pan wrote:    
> > > > > IOASIDs are used to associate DMA requests with virtual address
> > > > > spaces. They are a system-wide limited resource made available to
> > > > > the userspace applications. Let it be VMs or user-space device
> > > > > drivers.
> > > > > 
> > > > > This RFC patch introduces a cgroup controller to address the
> > > > > following problems:
> > > > > 1. Some user applications exhaust all the available IOASIDs thus
> > > > > depriving others of the same host.
> > > > > 2. System admins need to provision VMs based on their needs for
> > > > > IOASIDs, e.g. the number of VMs with assigned devices that perform
> > > > > DMA requests with PASID.      
> > > > 
> > > > Please take a look at the proposed misc controller:
> > > > 
> > > >  http://lkml.kernel.org/r/20210302081705.1990283-2-vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
> > > > 
> > > > Would that fit your bill?    
> > > The interface definitely can be reused. But IOASID has a different
> > > behavior in terms of migration and ownership checking. I guess SEV key
> > > IDs are not tied to a process whereas IOASIDs are. Perhaps this can be
> > > solved by adding
> > > +	.can_attach	= ioasids_can_attach,
> > > +	.cancel_attach	= ioasids_cancel_attach,
> > > Let me give it a try and come back.
> > >   
> > While I am trying to fit the IOASIDs cgroup in to the misc cgroup
> > proposal. I'd like to have a direction check on whether this idea of
> > using cgroup for IOASID/PASID resource management is viable.  
> 
> Yes, even for host SVA it would be good to have a cgroup. Currently the
> number of shared address spaces is naturally limited by number of
> processes, which can be controlled with rlimit and cgroup. But on Arm the
> hardware limit on shared address spaces is 64k (number of ASIDs), easily
> exhausted with the default PASID and PID limits. So a cgroup for managing
> this resource is more than welcome.
> 
> It looks like your current implementation is very dependent on
> IOASID_SET_TYPE_MM?  I'll need to do more reading about cgroup to see how
> easily it can be adapted to host SVA which uses IOASID_SET_TYPE_NULL.
> 
Right, I was assuming have three use cases of IOASIDs:
1. host supervisor SVA (not a concern, just one init_mm to bind)
2. host user SVA, either one IOASID per process or perhaps some private
IOASID for private address space
3. VM use for guest SVA, each IOASID is bound to a guest process

My current cgroup proposal applies to #3 with IOASID_SET_TYPE_MM, which is
allocated by the new /dev/ioasid interface.

For #2, I was thinking you can limit the host process via PIDs cgroup? i.e.
limit fork. So the host IOASIDs are currently allocated from the system pool
with quota of chosen by iommu_sva_init() in my patch, 0 means unlimited use
whatever is available. https://lkml.org/lkml/2021/2/28/18


> Thanks,
> Jean


Thanks,

Jacob
