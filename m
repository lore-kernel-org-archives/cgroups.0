From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Tue, 4 May 2021 15:00:50 -0300
Message-ID: <20210504180050.GB1370958@nvidia.com>
References: <20210421133312.15307c44@redhat.com>
 <20210421230301.GP1370958@nvidia.com>
 <MWHPR11MB1886188698A6E20338196F788C469@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210422121020.GT1370958@nvidia.com>
 <MWHPR11MB1886E688D2128C98A1F240B18C459@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210423114944.GF1370958@nvidia.com>
 <MWHPR11MB18861FE6982D73AFBF173E048C439@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210426123817.GQ1370958@nvidia.com>
 <MWHPR11MB188625137D5B7423822396C88C409@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210504084148.4f61d0b5@jacob-builder>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tES7OamPG2yhB1EsQjtDi+wmW2DPq3IAhbWd332A87w=;
 b=pCoR8RpzDIRFKAgAqVijxTfGIfVEEiXzE3iq5fP0oum8pe7jbZHPP7h8I41gXArpj8OozCYE8K4NyI19ZmfIORliZ0F60tM0zffvoqib2XXFhf77YspOEcfExLL6iZD+pKZm9k7FKw2PKRceVBbWKEvRfVqVRsGFOux21OFNG8RBUK3Uz9Z9U1mnN3I7TNpbGaGl/DHX90BIOwslNu5zyfTEyaoELCTpLMt5rkAo4NYWvjVfUSaIX3hGouMAGYgY4ORTyQcEsPOdekYzSi1RhryurLVEFqkZ6xsL6MH9O2jozpfilax6t9Pmrw2Wclc097fHWMbfay/rTzPTS1//5g==
Content-Disposition: inline
In-Reply-To: <20210504084148.4f61d0b5@jacob-builder>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Tue, May 04, 2021 at 08:41:48AM -0700, Jacob Pan wrote:
> > > 
> > > (also looking at ioasid.c, why do we need such a thin and odd wrapper
> > > around xarray?)
> > >   
> > 
> > I'll leave it to Jean and Jacob.

> Could you elaborate?

I mean stuff like this:

int ioasid_set_data(ioasid_t ioasid, void *data)
{
        struct ioasid_data *ioasid_data;
        int ret = 0;

        spin_lock(&ioasid_allocator_lock);
        ioasid_data = xa_load(&active_allocator->xa, ioasid);
        if (ioasid_data)
                rcu_assign_pointer(ioasid_data->private, data);
        else
                ret = -ENOENT;
        spin_unlock(&ioasid_allocator_lock);

        /*
         * Wait for readers to stop accessing the old private data, so the
         * caller can free it.
         */
        if (!ret)
                synchronize_rcu();

        return ret;
}
EXPORT_SYMBOL_GPL(ioasid_set_data);

It is a weird way to use xarray to have a structure which
itself is just a wrapper around another RCU protected structure.

Make the caller supply the ioasid_data memory, embedded in its own
element, get rid of the void * and rely on XA_ZERO_ENTRY to hold
allocated but not active entries.

Make the synchronize_rcu() the caller responsiblity, and callers
should really be able to use call_rcu()

Jason
