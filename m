From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v4 3/7] cgroup: protect cgroup->nr_(dying_)descendants by
 css_set_lock
Date: Mon, 3 Dec 2018 17:55:32 +0000
Message-ID: <20181203175525.GA31090@castle.DHCP.thefacebook.com>
References: <20181130234745.6756-1-guro@fb.com>
 <20181130234745.6756-4-guro@fb.com>
 <20181203161706.GL2509588@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=jXgZmmGrKJOCH7aXns46ZCD3NukG2hkqMLsh3ROlQSY=;
 b=pTraOz16Qug3Wy6ITtrBMdD8cBywjhMEQZvStRzMQ3+LJ2dK8yzp9XlE2Io7QgXV49gf
 0gSOwQ7B18CFpkV9MoP5L2LxmSETu4HyYMnKVRYAVPk+c+wI8W98yXpKYWHN+Xl2PDmy
 J5Ybxe5RZFZikvo19qITE82Emi50HlWQ3vc= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jXgZmmGrKJOCH7aXns46ZCD3NukG2hkqMLsh3ROlQSY=;
 b=NegAf/PUbTfQMkN4Jz/EF5FsiLbCJdThsiMPaHgVxvT1l+Iwbwf25Fgs+7/po7O3XcCkQ2RLHqi0rgyOm1TC1ldkWvVVmirVR4xKcKhQEY5uH56or7D0JGUvSeloLgNmwstR/t/+8ULDXZAThW2qH6jPD0NKDsXIry+aM68ZA8o=
In-Reply-To: <20181203161706.GL2509588@devbig004.ftw2.facebook.com>
Content-Language: en-US
Content-ID: <2BFDF386C6DA804C8707CAE220CD369C@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <guroan@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Dan Carpenter <dan.carpenter@oracle.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>

On Mon, Dec 03, 2018 at 08:17:06AM -0800, Tejun Heo wrote:
> On Fri, Nov 30, 2018 at 03:47:41PM -0800, Roman Gushchin wrote:
> > +	 * nr_descendants and nr_dying_descendants are protected
> > +	 * by cgroup_mutex and css_set_lock.
>=20
> Can you be a bit more specific - hold both for writes, either for
> reads.

Sure. Thanks!
