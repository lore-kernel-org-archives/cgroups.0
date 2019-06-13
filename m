From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH v2] cpuset: restore sanity to
 cpuset_cpus_allowed_fallback()
Date: Thu, 13 Jun 2019 14:02:29 +0200
Message-ID: <20190613120228.GA26668@blackbody.suse.cz>
References: <20190409204003.6428-1-jsavitz@redhat.com>
 <20190521143414.GJ5307@blackbody.suse.cz>
 <CAL1p7m6nfPkWoEEAjO+Gxq-ZiRY7+1jU_7dVcw2-hjC22xz-4A@mail.gmail.com>
 <20190528121036.GC31588@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190528121036.GC31588@blackbody.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Joel Savitz <jsavitz@redhat.com>
Cc: Li Zefan <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>, Waiman Long <longman@redhat.com>, Phil Auld <pauld@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, May 28, 2019 at 02:10:37PM +0200, Michal Koutn=FD  <MKoutny@suse.co=
m> wrote:
> Although, on v1 we will lose the "no longer affine to..." message
> (which is what happens in your demo IIUC).
FWIW, I was wrong, off by one 'state' transition. So the patch doesn't
cause change in messaging (not tested though).
