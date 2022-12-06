From: Chaitanya Kulkarni <chaitanyak-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] blk-cgroup: Fix typo in comment
Date: Tue, 6 Dec 2022 02:11:03 +0000
Message-ID: <503e6c9c-71c0-57d3-4e05-fbfd3870fb8d@nvidia.com>
References: <20221206093307.378249-1-shikemeng@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jdNi8KCoKMXwQNY1CFP9KuxnyY9A5blltKISfwicFmg=;
 b=WLeVBRkvwHu6BRhEZNuxviuANHgsVdK6jAe+GSn5R9jUp7LSMbPSOu/zOFVXIeLjMXfl0EBhM955Vg5LQ21FUOmBstzkTkcQZJjkf+T5s00eLnQi5+deZcH7Zbu7440knt9sUwAQtEUFDCgS9g2zdaqm2jbkMCDPGpJeznLwYNpx0r1Idc0qrNQrjkO+oidhZZ3LFKv7X3Rkuaa4fjTjYSTzJ/WbFSgJqXGbIIkrKf4Kd+dQEaWJ9uu/3gkXmh5114QtBmLYNpc29xaDhESOx1KFmaIPqVTnSgFkWQrUc2XFmqLJKgLfwY6QsOv9h6AjOCELMWyW3cTtluhqSXyLzg==
In-Reply-To: <20221206093307.378249-1-shikemeng-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Content-Language: en-US
Content-ID: <6D80D5B3881D3D4789A4198AABC9786C-asWib9pRmPqcE4WynfumptQqCkab/8FMAL8bYrjMMd8@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Kemeng Shi <shikemeng-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>, "tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org" <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, "axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org" <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linfeilong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <linfeilong-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "liuzhiqiang26-hv44wF8Li93QT0dZR+AlfA@public.gmane.org" <liuzhiqiang26-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

T24gMTIvNi8yMiAwMTozMywgS2VtZW5nIFNoaSB3cm90ZToNCj4gRnJvbTogS2VtZW5nIFNoaSA8
c2hpa2VtZW5nQGh1YXdlaS5jb20+DQo+IA0KPiBSZXBsYWNlIGFzc29jYXRpbmcgd2l0aCBhc3Nv
Y2lhdGluZy4NCj4gUmVwbGFjZSBpbnRpYWlsaXplZCB3aXRoIGluaXRpYWxpemVkLg0KPiANCj4g
U2lnbmVkLW9mZi1ieTogS2VtZW5nIFNoaSA8c2hpa2VtZW5nQGh1YXdlaS5jb20+DQo+IEFja2Vk
LWJ5OiBUZWp1biBIZW8gPHRqQGtlcm5lbC5vcmc+DQo+IFJldmlld2VkLWJ5OiBNdWtlc2ggT2po
YSA8cXVpY19tb2poYUBxdWljaW5jLmNvbT4NCj4gDQoNCkxvb2tzIGdvb2QuDQoNClJldmlld2Vk
LWJ5OiBDaGFpdGFueWEgS3Vsa2FybmkgPGtjaEBudmlkaWEuY29tPg0KDQotY2sNCg0K
