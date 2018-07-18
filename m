From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [BUG BISECT] "Support fs_context" causes systemd issues
 (linux-next)
Date: Wed, 18 Jul 2018 15:29:57 +0200
Message-ID: <20180718132957.GA17254@kroah.com>
References: <CAJKOXPftCn+qcJtG6bBjUMa2ZX=_YAoHkoYH69-+jSam4-z86Q@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAJKOXPftCn+qcJtG6bBjUMa2ZX=_YAoHkoYH69-+jSam4-z86Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Krzysztof =?utf-8?Q?Koz=C5=82owski?= <k.kozlowski.k@gmail.com>
Cc: David Howells <dhowells@redhat.com>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, fenghua.yu@intel.com, "linux-samsung-soc@vger.kernel.org" <linux-samsung-soc@vger.kernel.org>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, linux-kernel@vger.kernel.org

On Wed, Jul 18, 2018 at 01:46:35PM +0200, Krzysztof Koz=C5=82owski wrote:
> Hi,
>=20
> On recent linux-next, the commit f8076f3b0996 ("kernfs, sysfs, cgroup,
> intel_rdt: Support fs_context") causes weird behavior of two of
> systemd units: systemd-timesyncd.service and systemd-resolved.service
> fail to start.
>=20
> Logs:
>=20
> Jul 18 09:51:33 odroidu3 systemd[376]: systemd-timesyncd.service:
> Failed to set up mount namespacing: Invalid argument

Looks like the parsing for kernel mount options is broken somehow in the
above patch :(

thanks,

greg k-h
