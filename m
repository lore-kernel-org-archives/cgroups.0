From: Philipp Hahn <hahn@univention.de>
Subject: Bug#931111: linux-image-4.9.0-9: Memory "leak" caused by CGroup as used by pam_systemd
Date: Tue, 30 Jul 2019 18:06:52 +0200
Message-ID: <5c3dff05-3c32-19b8-d89e-f58ff123855b@univention.de>
References: <156154446841.16461.12659721223363969171.reportbug@fixa.knut.univention.de> <ad0222ca-5fb0-4177-dc82-ca63f079e942@univention.de> <aa31aa4f4f6c05df3f52f4bd99ceb6f0341ff482.camel@decadent.org.uk> <ad6a6d63-b61d-45c2-36f4-e7761bb58a3d@univention.de> <20190724144137.GB11425@castle.DHCP.thefacebook.com> <156154446841.16461.12659721223363969171.reportbug@fixa.knut.univention.de>
Reply-To: Philipp Hahn <hahn@univention.de>, 931111@bugs.debian.org
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <bounce-debian-bugs-dist=glddb-debian-bugs-dist2=m.gmane.org@lists.debian.org>
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.931111.B931111.15645028198644@bugs.debian.org>
In-Reply-To: <20190724144137.GB11425@castle.DHCP.thefacebook.com>
Content-Language: en-US
List-Id: <cgroups.vger.kernel.org>
List-URL: <https://lists.debian.org/debian-bugs-dist/>
List-Post: <mailto:debian-bugs-dist@lists.debian.org>
List-Help: <mailto:debian-bugs-dist-request@lists.debian.org?subject=help>
List-Subscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=subscribe>
List-Unsubscribe: <mailto:debian-bugs-dist-request@lists.debian.org?subject=unsubscribe>
Content-Type: text/plain; charset="windows-1252"
To: Roman Gushchin <guro@fb.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, "931111@bugs.debian.org" <931111@bugs.debian.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, =?UTF-8?Q?=E6=AE=B5=E7=86=8A=E6=98=A5?= <duanxiongchun@bytedance.com>

Hello,

Am 24.07.19 um 16:41 schrieb Roman Gushchin:
> On Wed, Jul 24, 2019 at 09:12:50AM +0200, Philipp Hahn wrote:
>> Am 24.07.19 um 00:03 schrieb Ben Hutchings:
...
>>> I would say this is a kernel bug.  I think it's the same problem that
>>> this patch series is trying to solve:
>>> https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__lwn.net_ml_linux=
-2Dkernel_20190611231813.3148843-2D1-2Dguro-40fb.com_&d=3DDwIDaQ&c=3D5VD0RT=
tNlTh3ycd41b3MUw&r=3DjJYgtDM7QT-W-Fz_d29HYQ&m=3DxNLFAB3gBGB1NCKmQZN-6JNEj_A=
XfJ3-wYK7IDWJAx4&s=3DYfWWnoW-zJdTN0hd1tzzZQlUIUtjv-iBN9Co5rNP5J0&e=3D=20
>>>
>>> Does the description there seem to match what you're seeing?
>>
>> Yes, Roman Gushchin replied to me by private mail, which I will quote
>> here to get his response archived in Debian's BTS as well:
...
>>> I've spent lot of time working on this problem, and the final patchset
>>> has been merged into 5.3. It implements reparenting of the slab memory
>>> on cgroup deletion. 5.3 should be much better in reclaiming dying cgrou=
ps.
>>>
>>> Unfortunately, the patchset is quite invasive and is based on some
>>> vmstats changes from 5.2, so it's not trivial to backport it to
>>> older kernels.
>>>
>>> Also, there is no good workaround, only manually dropping kernel
>>> caches or disable the kernel memory accounting as a whole.
...
>> So should someone=E2=84=A2 bite the bullet and try to backport Romans ch=
ange to
>> 4.19 (and 4.9)? (those are the kernel versions used by Debian).
>> I'm not a kernel expert myself, especially no mm/cg expert, but have
>> done some work myself in the past, but I would happily pass on the
>> chalice to someone more experienced.
>=20
> It's doable from the technical point of view, but I really doubt it's sui=
table
> for the official stable. The backport will consist of at least 20+ core
> mm/memcontrol patches, so it really feels excessive.
>=20
> If you still want to try, you need to backport 205b20cc5a99 first (and th=
e rest
> of the patchset), but it may also depend on some other vmstat changes.

I haven't yet started on trying the backport, but is there some process
to force free those dying cgroups manually?

I have found yet another report of this issue at
<https://github.com/moby/moby/issues/29638#issuecomment-514287415> and
there a cron-job

> 6 */12 * * * root echo 3 > /proc/sys/vm/drop_caches

is recommended. I tried that manually on one of our affected systems and
the number of memory cgroups only dropped marginally from 211_620 to
210_396 after doing the `drop_caches` multiple times and waiting for 10
minutes by now. On that idle system a lot of RAM is gone:
> # free -h
>               total        used        free      shared  buff/cache   ava=
ilable
> Mem:           141G         60G         80G         15M        755M      =
   80G

Thanks again for all your help.

Philipp

