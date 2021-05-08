From: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and allocation
 APIs
Date: Sat, 8 May 2021 05:46:09 +0000
Message-ID: <MWHPR11MB18861BF1CEA9AEA0B8CB2B0C8C569@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <20210421175203.GN1370958@nvidia.com>
 <20210421133312.15307c44@redhat.com> <20210421230301.GP1370958@nvidia.com>
 <MWHPR11MB1886188698A6E20338196F788C469@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210422121020.GT1370958@nvidia.com>
 <MWHPR11MB1886E688D2128C98A1F240B18C459@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210423114944.GF1370958@nvidia.com>
 <MWHPR11MB18861FE6982D73AFBF173E048C439@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210426123817.GQ1370958@nvidia.com>
 <MWHPR11MB188625137D5B7423822396C88C409@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210428204606.GX1370958@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QifxiqKM68aD+Y4zhQAHqfPHngOrU7xs8nSqzNmvdjk=;
 b=zMlZqR5yg1Z2aN2Va6OSrmGUVJggjdgzdD8HCMMSwO7CFO0XHtqq109N5y2rgOc0/XIzvnbe4Mr+PRqCxVXwab6AHnuIdIhjbEMNAaUshDkKjBEaL3J1U+ZZU5tpOyRQk6pL8uqVbxVURgGRbdalQbQWCNqOBRUSyyM5DCEniwU=
In-Reply-To: <20210428204606.GX1370958-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiBTZW50OiBUaHVyc2Rh
eSwgQXByaWwgMjksIDIwMjEgNDo0NiBBTQ0KPiANCj4gPiA+IEkgdGhpbmsgdGhlIG5hbWUgSU9B
U0lEIGlzIGZpbmUgZm9yIHRoZSB1QVBJLCB0aGUga2VybmVsIHZlcnNpb24gY2FuDQo+ID4gPiBi
ZSBjYWxsZWQgaW9hc2lkX2lkIG9yIHNvbWV0aGluZy4NCj4gPg0KPiA+IGlvYXNpZCBpcyBhbHJl
YWR5IGFuIGlkIGFuZCB0aGVuIGlvYXNpZF9pZCBqdXN0IGFkZHMgY29uZnVzaW9uLiBBbm90aGVy
DQo+ID4gcG9pbnQgaXMgdGhhdCBpb2FzaWQgaXMgY3VycmVudGx5IHVzZWQgdG8gcmVwcmVzZW50
IGJvdGggUENJIFBBU0lEIGFuZA0KPiA+IEFSTSBzdWJzdHJlYW0gSUQgaW4gdGhlIGtlcm5lbC4g
SXQgaW1wbGllcyB0aGF0IGlmIHdlIHdhbnQgdG8gc2VwYXJhdGUNCj4gPiBpb2FzaWQgYW5kIHBh
c2lkIGluIHRoZSB1QVBJIHRoZSAncGFzaWQnIGFsc28gbmVlZHMgdG8gYmUgcmVwbGFjZWQgd2l0
aA0KPiA+IGFub3RoZXIgZ2VuZXJhbCB0ZXJtIHVzYWJsZSBmb3Igc3Vic3RyZWFtIElELiBBcmUg
d2UgbWFraW5nIHRoZQ0KPiA+IHRlcm1zIHRvbyBjb25mdXNpbmcgaGVyZT8NCj4gDQo+IFRoaXMg
aXMgd2h5IEkgYWxzbyBhbSBub3Qgc28gc3VyZSBhYm91dCBleHBvc2luZyB0aGUgUEFTSUQgaW4g
dGhlIEFQSQ0KPiBiZWNhdXNlIGl0IGlzIHVsdGltYXRlbHkgYSBIVyBzcGVjaWZpYyBpdGVtLg0K
PiANCj4gQXMgSSBzYWlkIHRvIERhdmlkLCBvbmUgYXZlbnVlIGlzIHRvIGhhdmUgc29tZSBnZW5l
cmljIHVBUEkgdGhhdCBpcw0KPiB2ZXJ5IGdlbmVyYWwgYW5kIGtlZXAgYWxsIHRoaXMgZGVlcGx5
IGRldGFpbGVkIHN0dWZmLCB0aGF0IHJlYWxseSBvbmx5DQo+IG1hdHRlcnMgZm9yIHFlbXUsIGFz
IHBhcnQgb2YgYSBtb3JlIEhXIHNwZWNpZmljIHZJT01NVSBkcml2ZXINCj4gaW50ZXJmYWNlLg0K
PiANCg0KT0ssIHNvIHRoZSBnZW5lcmFsIHVBUEkgd2lsbCBub3QgZXhwb3NlIGh3X2lkIGFuZCBq
dXN0IHByb3ZpZGUgZXZlcnl0aGluZw0KZ2VuZXJpYyBmb3IgbWFuYWdpbmcgSS9PIHBhZ2UgdGFi
bGUgKG1hcC91bm1hcCwgbmVzdGluZywgZXRjLikgdGhyb3VnaCANCklPQVNJRCBhbmQgdGhlbiBz
cGVjaWZpYyB1QVBJIGlzIHByb3ZpZGVkIHRvIGhhbmRsZSBwbGF0Zm9ybSBzcGVjaWZpYw0KcmVx
dWlyZW1lbnRzIChod19pZCwgaW92YSB3aW5kb3dzLCBldGMuKQ0KDQpUaGFua3MNCktldmluDQo=
