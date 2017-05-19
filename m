From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 00/31] Standardize doc formats - part 1
Date: Thu, 18 May 2017 22:22:05 -0300
Message-ID: <cover.1495156488.git.mchehab@s-opensource.com>
Return-path: <linux-doc-owner@vger.kernel.org>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>, Mauro Carvalho Chehab <mchehab@infradead.org>, linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, David Woodhouse <dwmw2@infradead.org>, Brian Norris <computersforpeace@gmail.com>, Boris Brezillon <boris.brezillon@free-electrons.com>, Marek Vasut <marek.vasut@gmail.com>, Richard Weinberger <richard@nod.at>, Cyrille Pitchen <cyrille.pitchen@atmel.com>, linux-mtd@lists.infradead.org, tboot-devel@lists.sourceforge.net, Emese Revfy <re.emese@gmail.com>, Li Zefan <lizefan@huawei.com>, Ning Sun <ning.sun@intel.com>, Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>, linux-crypto@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, Johann

Each document under Documentation/*.txt has its own format.
Some follow markup notations, some don't even have a title!

In order to try to get some order on it, change the document
style to the standard we're adopting after the adoption of
ReStructured Text.

The documents touched on this series now build fine with
Sphinx, if renamed to *.rst extension.

The main goal with this is to teach people by example about
what format is expected on newer documents. It also helps
to add those files to Kernel books.

In order to make things more palatable, I'm spliting the
conversion into three parts.

This is part 1.

Mauro Carvalho Chehab (31):
  bcache.txt: standardize document format
  bt8xxgpio.txt: standardize document format
  btmrvl.txt: standardize document format
  bus-virt-phys-mapping.txt: standardize document format
  cachetlb.txt: standardize document format
  cgroup-v2.txt: standardize document format
  circular-buffers.txt: standardize document format
  clk.txt: standardize document format
  cpu-load: standardize document format
  cputopology.txt: standardize document format
  crc32.txt: standardize document format
  dcdbas.txt: standardize document format
  digsig.txt: standardize document format
  DMA-API.txt: standardize document format
  DMA-API-HOWTO.txt: standardize document format
  DMA-attributes.txt: standardize document format
  DMA-ISA-LPC.txt: standardize document format
  debugging-via-ohci1394.txt: standardize document format
  efi-stub.txt: standardize document format
  eisa.txt: standardize document format
  flexible-arrays.txt: standardize document format
  futex-requeue-pi.txt: standardize document format
  gcc-plugins.txt: standardize document format
  highuid.txt: standardize document format
  hw_random.txt: standardize document format
  hwspinlock.txt: standardize document format
  intel_txt.txt: standardize document format
  Intel-IOMMU.txt: standardize document format
  io-mapping.txt: standardize document format
  io_ordering.txt: standardize document format
  iostats.txt: standardize document format

 Documentation/DMA-API-HOWTO.txt          | 159 +++++----
 Documentation/DMA-API.txt                | 575 ++++++++++++++++++-------------
 Documentation/DMA-ISA-LPC.txt            |  71 ++--
 Documentation/DMA-attributes.txt         |  15 +-
 Documentation/Intel-IOMMU.txt            |  36 +-
 Documentation/bcache.txt                 | 200 ++++++-----
 Documentation/bt8xxgpio.txt              |  19 +-
 Documentation/btmrvl.txt                 |  64 ++--
 Documentation/bus-virt-phys-mapping.txt  |  63 ++--
 Documentation/cachetlb.txt               |  92 ++---
 Documentation/cgroup-v2.txt              | 449 ++++++++++++------------
 Documentation/circular-buffers.txt       |  51 ++-
 Documentation/clk.txt                    | 189 +++++-----
 Documentation/cpu-load.txt               | 117 +++----
 Documentation/cputopology.txt            |  35 +-
 Documentation/crc32.txt                  |  75 ++--
 Documentation/dcdbas.txt                 |  24 +-
 Documentation/debugging-via-ohci1394.txt |  21 +-
 Documentation/digsig.txt                 | 124 +++----
 Documentation/efi-stub.txt               |  25 +-
 Documentation/eisa.txt                   | 260 +++++++-------
 Documentation/flexible-arrays.txt        |  24 +-
 Documentation/futex-requeue-pi.txt       |  83 ++---
 Documentation/gcc-plugins.txt            |  58 ++--
 Documentation/highuid.txt                |  46 +--
 Documentation/hw_random.txt              | 158 +++++----
 Documentation/hwspinlock.txt             | 527 ++++++++++++++++------------
 Documentation/intel_txt.txt              |  63 ++--
 Documentation/io-mapping.txt             |  67 ++--
 Documentation/io_ordering.txt            |  61 ++--
 Documentation/iostats.txt                |  40 ++-
 31 files changed, 2101 insertions(+), 1690 deletions(-)

-- 
2.9.4


