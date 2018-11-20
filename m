From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v3 4/7] cgroup: cgroup v2 freezer
Date: Tue, 20 Nov 2018 17:39:03 +0000
Message-ID: <20181120173858.GC21462@tower.DHCP.thefacebook.com>
References: <20181117003830.15344-1-guro@fb.com>
 <20181117003830.15344-5-guro@fb.com>
 <20181120162529.GU2509588@devbig004.ftw2.facebook.com>
 <20181120163304.GA21462@tower.DHCP.thefacebook.com>
 <20181120163604.GX2509588@devbig004.ftw2.facebook.com>
 <20181120164349.GB21462@tower.DHCP.thefacebook.com>
 <20181120164859.GY2509588@devbig004.ftw2.facebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=pLJmpNR42xWZjxlbuIeDtN22i4yM9M666IQ0eJ+zUWE=;
 b=eeZNHoEayLd+/OY/3OCsM130voVvzOjUGlyozABQBQRTamNvk+NPplKvc0ZI9FlcoD0U
 E2hkx/DJ7DHTtjJX+lim+ViqW2s9fWooCv7pWyYFbQsY4PKiS6LXK57sBqtziZpyL9Sb
 /RKnEsU7p7Y/4JxyaFuPLccQ42lfoqEl6Nc= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pLJmpNR42xWZjxlbuIeDtN22i4yM9M666IQ0eJ+zUWE=;
 b=MMI2nc565gQ6iZaY393AK5mY2Ygac1Lv6kRflUhgZ/A+AXR7puxaEJzu4Ze4qqBUaSuhD+bZVnt18gmzQ4VWz0F3wBxoWo00V4PLIGmCN6lrUDsea0fCK0smZOfesIM7+SsHZPNH04y2wbPT6pzZgpk+N1Zd2eNJBzjjQH1KBjA=
In-Reply-To: <20181120164859.GY2509588@devbig004.ftw2.facebook.com>
Content-Language: en-US
Content-ID: <ED3B4FA8405D0345AAFB57A5FA827BF5@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <guroan@gmail.com>, Oleg Nesterov <oleg@redhat.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>

On Tue, Nov 20, 2018 at 08:48:59AM -0800, Tejun Heo wrote:
> Hello,
>=20
> On Tue, Nov 20, 2018 at 04:43:52PM +0000, Roman Gushchin wrote:
> > > But that wouldn't udpate the cgroup's frozen state and generate
> > > notifications, right?
> >=20
> > Why? The task will be eventually trapped into cgroup_enter_frozen(),
> > and from there cgroup_update_frozen() will be called.
>=20
> Because the cgroup is no longer frozen?
>=20
> > You are right, that notification will not be issued, because the cgroup
> > is not changing its state (frozen->frozen). I'm not sure that it makes
> > sense to change the cgroup state back and forth in this case. Are there
> > any reasons I'm missing?
>=20
> Imagine the task being trapped in nfs or wherever and not getting into
> the freezer for an extended period of time.

Yeah, it's a good point. I've thought about it mostly in the fork() context=
,
where if freezing of a cgroup races with fork(), it makes no sense to
switch the cgroup state back and forth. But that case is different, as
the child will be trapped just on the return path from fork() call.

Thanks!
