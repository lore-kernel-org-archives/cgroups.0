From: Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Fri, 19 Mar 2021 10:58:41 +0100
Message-ID: <YFR10eeDVf5ZHV5l@myrica>
References: <1614463286-97618-1-git-send-email-jacob.jun.pan@linux.intel.com>
 <1614463286-97618-6-git-send-email-jacob.jun.pan@linux.intel.com>
 <20210318172234.3e8c34f7@jacob-builder>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=+ew0oK+98acMtQgKLGerzyoNXnWF03GfXmL2rWxicfk=;
 b=UdvS3qSDTfqH6Y/9ofxlqvCMdGhYTHBMlEKvkuSNFIAbXj3Iw7mjRPnscCsrtOHM5G
 MlOFed3B9j8sNv6cKE1CjkDG7IVfJZaejlQLQHjinhmn4md6lO9XFnLYwz+70nP+jRDQ
 Z5fs4LXC67m6l5OhlLif7iHkDnjNtHEEH8Un5AjM4d/DNim7CCkfGj9IPPbiGnACMtVL
 9Zuh84uDGYWvyZbcQ+M9KjO0nCzsdA+CCKhBixRmtofebvqO9UQMbXS2Ktix/fxZ3r4N
 ktpSWYrVOqT0PqvQqWuidhdHYwmu0PFpnGYb/SHBosxdSqn1KgYSTXs5RpmVr3XP5Hqg
 ixMA==
Content-Disposition: inline
In-Reply-To: <20210318172234.3e8c34f7@jacob-builder>
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
To: Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Raj Ashok <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

Hi Jacob,

On Thu, Mar 18, 2021 at 05:22:34PM -0700, Jacob Pan wrote:
> Hi Jean,
> 
> Slightly off the title. As we are moving to use cgroup to limit PASID
> allocations, it would be much simpler if we enforce on the current task.

Yes I think we should do that. Is there a problem with charging the
process that does the PASID allocation even if the PASID indexes some
other mm?

> However, iommu_sva_alloc_pasid() takes an mm_struct pointer as argument
> which implies it can be something other the the current task mm. So far all
> kernel callers use current task mm. Is there a use case for doing PASID
> allocation on behalf of another mm? If not, can we remove the mm argument?

This would effectively remove the mm parameter from
iommu_sva_bind_device(). I'm not opposed to that, but reintroducing it
later will be difficult if IOMMU drivers start assuming that the bound mm
is from current.

Although there is no use for it at the moment (only two upstream users and
it looks like amdkfd always uses current too), I quite like the
client-server model where the privileged process does bind() and programs
the hardware queue on behalf of the client process.

Thanks,
Jean
