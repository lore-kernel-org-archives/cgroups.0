From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v6 85/99] btrfs: Remove unused spinlock
Date: Thu, 18 Jan 2018 15:22:34 +0100
Message-ID: <20180118142234.GK13726@twin.jikos.cz>
References: <20180117202203.19756-1-willy@infradead.org>
 <20180117202203.19756-86-willy@infradead.org>
Reply-To: dsterba@suse.cz
Mime-Version: 1.0
Content-Transfer-Encoding: base64
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
Content-Disposition: inline
In-Reply-To: <20180117202203.19756-86-willy@infradead.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/intel-gfx>
List-Post: <mailto:intel-gfx@lists.freedesktop.org>
List-Help: <mailto:intel-gfx-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=subscribe>
Errors-To: intel-gfx-bounces@lists.freedesktop.org
Sender: "Intel-gfx" <intel-gfx-bounces@lists.freedesktop.org>
Content-Type: text/plain; charset="us-ascii"
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-s390@vger.kernel.org, David Howells <dhowells@redhat.com>, linux-nilfs@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, linux-sh@vger.kernel.org, intel-gfx@lists.freedesktop.org, linux-usb@vger.kernel.org, linux-remoteproc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, linux-mm@kvack.org, iommu@lists.linux-foundation.org, Stefano Stabellini <sstabellini@kernel.org>, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, Bjorn Andersson <bjorn.andersson@linaro.org>, linux-btrfs@vger.kernel.org

T24gV2VkLCBKYW4gMTcsIDIwMTggYXQgMTI6MjE6NDlQTSAtMDgwMCwgTWF0dGhldyBXaWxjb3gg
d3JvdGU6Cj4gRnJvbTogTWF0dGhldyBXaWxjb3ggPG1hd2lsY294QG1pY3Jvc29mdC5jb20+Cj4g
Cj4gVGhlIHJlYWRhX2xvY2sgaW4gc3RydWN0IGJ0cmZzX2RldmljZSB3YXMgb25seSBpbml0aWFs
aXNlZCwgYW5kIG5vdAo+IGFjdHVhbGx5IHVzZWQuICBUaGF0J3MgZ29vZCBiZWNhdXNlIHRoZXJl
J3MgYW5vdGhlciBsb2NrIGFsc28gY2FsbGVkCj4gcmVhZGFfbG9jayBpbiB0aGUgYnRyZnNfZnNf
aW5mbyB0aGF0IHdhcyBxdWl0ZSBoZWF2aWx5IHVzZWQuICBSZW1vdmUKPiB0aGlzIG9uZS4KPiAK
PiBTaWduZWQtb2ZmLWJ5OiBNYXR0aGV3IFdpbGNveCA8bWF3aWxjb3hAbWljcm9zb2Z0LmNvbT4K
CkknbGwgcGljayB0aGlzIG9uZSBub3csIHRoYW5rcy4KX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX18KSW50ZWwtZ2Z4IG1haWxpbmcgbGlzdApJbnRlbC1nZnhA
bGlzdHMuZnJlZWRlc2t0b3Aub3JnCmh0dHBzOi8vbGlzdHMuZnJlZWRlc2t0b3Aub3JnL21haWxt
YW4vbGlzdGluZm8vaW50ZWwtZ2Z4Cg==
