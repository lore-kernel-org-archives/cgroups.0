From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH 4/5] mm: rework non-root kmem_cache lifecycle management
Date: Thu, 18 Apr 2019 18:04:27 +0000
Message-ID: <20190418180421.GA11008@tower.DHCP.thefacebook.com>
References: <20190417215434.25897-1-guro@fb.com>
 <20190417215434.25897-5-guro@fb.com>
 <0100016a30a83bcf-7f99039c-77ec-4c48-a1c4-92e398f8f185-000000@email.amazonses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=nyD1XsBQY82CeJGECiRnHzq5/mZwh+IClLs8oH+5N10=;
 b=Sa0qcggn9/W1DCYcoKMn1EqwHPtOe/VOZdPTKrWFStfkochgbfuOjSksgVWUnFKSOJ8P
 2PEiX50mr1rcRzp2wVI0QWRbgIUrraRVXGG8lgSp9IbzCMLE8I1w7sTp43mcyqS9kFJ0
 9mUpo1JlCQwOu9IPkqX7FYJd9GINxpvTUpE= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nyD1XsBQY82CeJGECiRnHzq5/mZwh+IClLs8oH+5N10=;
 b=UbZ7bYAjhMOyu6cogHZN0iRwgYu0i3VJMqeSfFKKlrFml9HMrZDIWK0P43o2Kd8gyts66OszOXw0tn83ilevBIiQBm4legnczn4aBwIH2S1wjXj8RwY3IjpQgyhFMT+uBydsZzGQKH8dwVgghShISsbAlGkPL3hda8o9DvXygYo=
In-Reply-To: <0100016a30a83bcf-7f99039c-77ec-4c48-a1c4-92e398f8f185-000000@email.amazonses.com>
Content-Language: en-US
Content-ID: <C681190BAEEB0F48889A8944DCADA4D8@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Christopher Lameter <cl@linux.com>
Cc: Roman Gushchin <guroan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Rik van Riel <riel@surriel.com>, "david@fromorbit.com" <david@fromorbit.com>, Pekka Enberg <penberg@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>

On Thu, Apr 18, 2019 at 01:34:52PM +0000, Christopher Lameter wrote:
> On Wed, 17 Apr 2019, Roman Gushchin wrote:
>=20
> > Let's make every page to hold a reference to the kmem_cache (we
> > already have a stable pointer), and make kmem_caches to hold a single
> > reference to the memory cgroup.
>=20
> Ok you are freeing one word in the page struct that can be used for other
> purposes now?
>=20

Looks so!
